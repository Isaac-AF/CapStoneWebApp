class WorkoutsController < ApplicationController
  def index
    matching_workouts = Workout.all

    @list_of_workouts = matching_workouts.order({ :created_at => :desc })

    render({ :template => "workouts/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_workouts = Workout.where({ :id => the_id })

    @the_workout = matching_workouts.at(0)

    render({ :template => "workouts/show" })
  end

  def ai_process
    the_activity = params.fetch("query_activity_type", "")
    the_duration = params.fetch("query_activity_time", "")
    the_description = params.fetch("description_param", "")

    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert personal trainer. Your job is to estimate the calories that the user burned based on the activity they did, the duration, and information about the user such as their height and weight. Please also give a rating on a scale of 1-10 how good the activity was at helping the user accomplish their goals.")
    chat.schema = '{
      "name": "activity_info",
      "schema": {
        "type": "object",
        "properties": {
          "calories": {
            "type": "number",
            "description": "Total calories in kcal."
          },
          "rating": {
            "type": "integer",
            "description": "A rating on a scale of 1-10 how healthy the meal is."
          }
        },
        "required": [
          "calories",
          "rating"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    chat.user("The activity completed was: #{the_activity}")
    chat.user("The time for which the activity was done was: #{the_duration}")
    chat.user("Here's a description of the activity: #{the_description}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}.")

    result = chat.assistant!

    calories = result.fetch("calories")
    rating = result.fetch("rating")
    
        
    new_activity = Workout.new
    new_activity.workout_datetime = params.fetch("query_activity_date")
    new_activity.user_id = current_user.id
    new_activity.workout_type = the_activity
    new_activity.calories_burned = calories
    new_activity.rating = rating

    if new_activity.valid?
      new_activity.save
      redirect_to("/users/#{current_user.id}", { :notice => "Workout created successfully." })
    else
      redirect_to("/workouts", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def manual_insert
    new_activity = Workout.new
    new_activity.workout_datetime = params.fetch("query_activity_date")
    new_activity.user_id = current_user.id
    new_activity.workout_type = params.fetch("query_activity_type")
    new_activity.calories_burned = params.fetch("query_calories")

    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert personal trainer. Given an activity, duration and calories burned, your job is to give a rating on a scale of 1-10 how good the activity was at helping the user accomplish their goals using information about the user such as their height and weight.")
    chat.schema = '{
      "name": "activity_info",
      "schema": {
        "type": "object",
        "properties": {
            "rating": {
            "type": "integer",
            "description": "A rating on a scale of 1-10 of good the activity was."
          }
        },
        "required": [
          "rating"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    chat.user("The activity completed was: #{params.fetch("query_activity_type")}")
    chat.user("The time for which the activity was done was: #{params.fetch("query_activity_time")}")
    chat.user("The calories burned were: #{params.fetch("query_calories")}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}.")

    result = chat.assistant!

    new_activity.rating = result.fetch("rating")

    if new_activity.valid?
      new_activity.save
      redirect_to("/users/#{current_user.id}", { :notice => "Workout created successfully." })
    else
      redirect_to("/workouts", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end


  def update
    the_id = params.fetch("path_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    the_workout.workout_datetime = params.fetch("query_workout_datetime")
    the_workout.user_id = params.fetch("query_user_id")
    the_workout.workout_sets_count = params.fetch("query_workout_sets_count")

    if the_workout.valid?
      the_workout.save
      redirect_to("/workouts/#{the_workout.id}", { :notice => "Workout updated successfully."} )
    else
      redirect_to("/workouts/#{the_workout.id}", { :alert => the_workout.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    the_workout.destroy

    redirect_to("/workouts", { :notice => "Workout deleted successfully."} )
  end
end
