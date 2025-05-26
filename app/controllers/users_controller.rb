class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :update, :destroy]
  def index
    render({ :template => "users/index" })
  end

  def show
    render({ :template => "users/show" })
  end

  def update
    the_id = params.fetch("path_id")
    the_user = user.where({ :id => the_id }).at(0)

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "user updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def recommend
    chat = OpenAI::Chat.new
    chat.model = 'o3-mini'
    chat.system("You are an expert nutritionist. Given a list of meals a user has already eaten and their personal goals, recommend some food ideas that they could use to meet their goal for the day.")
    chat.schema = '{
      "name": "food_recommend",
      "schema": {
        "type": "object",
        "properties": {
          "recommendation": {
            "type": "string",
            "description": "Recommended food for the rest of the day to hit goals."
          }
        },
        "required": [
          "recommendation"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    meals = Meal.where(user_id: current_user.id, date_consumed: Date.current)

    formatted_data = meals.map do |set|
      "#{set.meal_type}: #{set.food_name} - Calories: #{set.calories} kcal, Protein: #{set.protein} g, Fats:  #{set.fats} g, Carbs:  #{set.carbs} g, Fiber:  #{set.fiber} g"
    end.join("\n")

    chat.user("Here is a log of the user's meals from the day: #{formatted_data}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}. Their daily nutrition targets are #{current_user.target_calories} kcal calories, #{current_user.target_protein} g protein, #{current_user.target_carbs} g carbohydrates, #{current_user.target_fat} g fats, and #{current_user.target_fiber} g fiber.")

    if !current_user.dietary_restrictions.blank?
      chat.user("The user's dietary restrictions are: #{current_user.dietary_restrictions}.")
    end
    
    result = chat.assistant!

    recommendation = result.fetch("recommendation")

    key = "rec_#{current_user.id}_#{SecureRandom.hex(4)}"
    Rails.cache.write(key, recommendation, expires_in: 15.minutes)

    redirect_to("/users/#{current_user.id}?rec_key=#{key}")
  end

  def rate_nutrition
    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert nutritionist. Given a list of meals a user has eaten over the past week and their personal goals, give some encouragement for what they're doing well, and provide some recommendations for how they can improve.")
    chat.schema = '{
      "name": "diet_recommend",
      "schema": {
        "type": "object",
        "properties": {
          "recommendation": {
            "type": "string",
            "description": "Recommend how user can improve diet to meet their goals."
          }
        },
        "required": [
          "recommendation"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    meals = Meal.where(user_id: current_user.id, date_consumed: 8.days.ago.to_date..(Date.current - 1))

    formatted_data = meals.map do |set|
      "#{set.date_consumed} #{set.meal_type}: #{set.food_name} - Calories: #{set.calories} kcal, Protein: #{set.protein} g, Fats:  #{set.fats} g, Carbs:  #{set.carbs} g, Fiber:  #{set.fiber} g"
    end.join("\n")

    chat.user("Here is a log of the user's meals from the past week: #{formatted_data}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}. Their daily nutrition targets are #{current_user.target_calories} kcal calories, #{current_user.target_protein} g protein, #{current_user.target_carbs} g carbohydrates, #{current_user.target_fat} g fats, and #{current_user.target_fiber} g fiber.")

    if !current_user.dietary_restrictions.blank?
      chat.user("The user's dietary restrictions are: #{current_user.dietary_restrictions}.")
    end

    result = chat.assistant!

    recommendation = result.fetch("recommendation")

    key = "rec_#{current_user.id}_#{SecureRandom.hex(4)}"
    Rails.cache.write(key, recommendation, expires_in: 15.minutes)

    redirect_to("/users/#{current_user.id}?rec_key=#{key}")
  end

def rate_activity
    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert personal trainer. Given a list of activities a user has completed over the past week and specifics of their workouts, give some encouragement for what they're doing well, and provide some recommendations for how they can improve. For strength training workouts, recommend changes to the workouts themselves (such as different exercises) if needed.")
    chat.schema = '{
      "name": "activity_recommend",
      "schema": {
        "type": "object",
        "properties": {
          "recommendation": {
            "type": "string",
            "description": "Recommend how user can improve workouts to meet their goals."
          }
        },
        "required": [
          "recommendation"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    activities = Workout.where(user_id: current_user.id, workout_datetime: 8.days.ago.beginning_of_day..1.day.ago.end_of_day)

    formatted_data = activities.map do |set|
      "Date and time of activity: #{set.workout_datetime}, Type of activity: #{set.workout_type}, Estimated Calories Burned: #{set.calories_burned} kcal"
    end.join("\n")

    chat.user("Here is a log of the user's activity from the past week: #{formatted_data}")

    workout_sets = WorkoutSet.joins(:workout).where(workouts:{ user_id: current_user.id}).where(created_at: 8.days.ago.beginning_of_day..1.day.ago.end_of_day)

    formatted_data = workout_sets.map do |set|
      "Date and time of workout set: #{set.created_at}, Exercise Name: #{set.exercise.exercise_name}, Number of reps: #{set.workout_reps_count}, Weight: #{set.weight} lbs."
    end.join("\n")

    chat.user("Here is a log of the user's workout sets from the past week: #{formatted_data}")

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their height is #{current_user.height} inches, their weight is #{current_user.weight} pounds, their sex is #{current_user.sex}, their birthday is #{current_user.birthday}, and their self-described activity level is #{current_user.activity_level}. Their daily nutrition targets are #{current_user.target_calories} kcal calories, #{current_user.target_protein} g protein, #{current_user.target_carbs} g carbohydrates, #{current_user.target_fat} g fats, and #{current_user.target_fiber} g fiber.")

    result = chat.assistant!

    recommendation = result.fetch("recommendation")

    key = "rec_#{current_user.id}_#{SecureRandom.hex(4)}"
    Rails.cache.write(key, recommendation, expires_in: 15.minutes)

    redirect_to("/users/#{current_user.id}?rec_key=#{key}")
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = user.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "user deleted successfully."} )
  end
end
