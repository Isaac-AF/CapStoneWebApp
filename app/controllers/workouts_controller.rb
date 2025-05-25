class WorkoutsController < ApplicationController
  def index
    render({ :template => "workouts/index" })
  end

  def show
    user_id = params.fetch("user_id")
    date = Date.parse(params.fetch("date"))
    
    start_of_day = date.beginning_of_day
    end_of_day = date.end_of_day

    @matching_workouts = Workout.where(user_id: user_id).where(workout_datetime: start_of_day..end_of_day).order(:workout_datetime)

    render({ template: "workouts/show" })
  end

  def create
    new_activity = Workout.new
    new_activity.workout_datetime = Time.current
    new_activity.user_id = current_user.id
    new_activity.workout_type = "Strength Training"

    new_activity.save

    redirect_to("/workout_sets/#{new_activity.id}", { :notice => "Activity created successfully." })
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
            "description": "A rating on a scale of 1-10 how good the activity was."
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
      redirect_to("/users/#{current_user.id}", { :notice => "Activity created successfully." })
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
            "description": "A rating on a scale of 1-10 of how good the activity was."
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
      redirect_to("/users/#{current_user.id}", { :notice => "Activity created successfully." })
    else
      redirect_to("/workouts", { :alert => new_activity.errors.full_messages.to_sentence })
    end
  end


  def update
    the_id = params.fetch("workout_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    the_workout.workout_datetime = params.fetch("query_date_time")
    the_workout.workout_type = params.fetch("query_workout_type")
    the_workout.calories_burned = params.fetch("query_calories")
    the_workout.rating = params.fetch("query_rating")
    
    user_id = current_user.id
    date = the_workout.workout_datetime.to_date

    if the_workout.valid?
      the_workout.save
      redirect_to("/workouts/#{date}/#{user_id}", { :notice => "Activity updated successfully."} )
    else
      redirect_to("/workouts/#{date}/#{user_id}", { :alert => the_workout.errors.full_messages.to_sentence })
    end
  end

def finish
    workout_id = params.fetch("query_workout_id")
    the_workout = Workout.where({ :id => workout_id }).at(0)

    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert personal trainer. Your job is to estimate the calories that the user burned based on the workout they completed, the duration, and information about the user such as their height and weight. Please also give a rating on a scale of 1-10 how good the activity was at helping the user accomplish their goals.")
    chat.schema = '{
      "name": "activity_info",
      "schema": {
        "type": "object",
        "properties": {
          "calories": {
            "type": "integer",
            "description": "Estimated calories in kcal."
          },
            "rating": {
            "type": "integer",
            "description": "A rating on a scale of 1-10 of how good the activity was."
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

    workout_sets = WorkoutSet.includes(:exercise).where(workout_id: workout_id)

    formatted_data = workout_sets.map do |set|
      "#{set.exercise.exercise_name}: #{set.workout_reps_count} reps at #{set.weight} lbs"
    end.join("\n")

    chat.user("Here is a log of the user's workout: #{formatted_data}")
    chat.user("The duration of the workout was: #{the_workout.workout_datetime - Time.current}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}.")

    result = chat.assistant!

    the_workout.calories_burned = result.fetch("calories")
    the_workout.rating = result.fetch("rating")

    the_workout.save

    redirect_to("/users/#{current_user.id}", { :notice => "Workout completed successfully." })
  end

  def destroy
    the_id = params.fetch("workout_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    user_id = current_user.id
    date = the_workout.workout_datetime.to_date

    the_workout.destroy

    remaining = Workout.where(user_id: user_id).where("DATE(workout_datetime) = ?", date)
    if remaining.exists?
      redirect_to("/workouts/#{date}/#{user_id}", { :notice => "Activity deleted successfully."} )
    else
      redirect_to "/workouts"
    end
  end

  def delete_if_empty_and_back
    workout_id = params.fetch("workout_id")
    workout = Workout.find_by(id: workout_id)

    workout.destroy

    redirect_to "/users/#{current_user.id}"
  end 
end
