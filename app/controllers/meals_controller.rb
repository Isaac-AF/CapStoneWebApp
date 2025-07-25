class MealsController < ApplicationController
  def index
    render({ :template => "meals/index" })
  end

  def show
    user_id = params.fetch("user_id")
    date = params.fetch("date")

    @matching_meals = Meal.where({ :user_id => user_id, :date_consumed => date})

    render({ :template => "meals/show" })
  end

  def ai_process
    the_images = params[:image_param]
    the_description = params.fetch("description_param", "")

    chat = OpenAI::Chat.new
    chat.model = 'o4-mini'
    chat.system("You are an expert nutritionist. Your job is to estimate how many grams of carbohydrates, grams of protein, grams of fat, grams of fiber, and total calories are in a meal. The user will provide either photos, a description, or both. The photos may be an image of the food itself, a recipe that was used to prepare the food, a picture of a menu, or a barcode that should be used to look up the nutrition facts of the item. If necessary, search the web for nutrition information for specific menu items (like a McDonald's cheeseburger or the barcode from a granola bar). Please also give a rating on a scale of 1-10 how healthy the meal is given the macros provided and the user's goals.")
    chat.schema = '{
      "name": "nutrition_info",
      "schema": {
        "type": "object",
        "properties": {
          "carbohydrates": {
            "type": "number",
            "description": "Amount of carbohydrates in grams."
          },
          "protein": {
            "type": "number",
            "description": "Amount of protein in grams."
          },
          "fat": {
            "type": "number",
            "description": "Amount of fat in grams."
          },
          "total_calories": {
            "type": "number",
            "description": "Total calories in kcal."
          },
          "fiber": {
            "type": "number",
            "description": "Amount of fiber in grams."
          },
          "rating": {
            "type": "integer",
            "description": "A rating on a scale of 1-10 how healthy the meal is."
          }
        },
        "required": [
          "carbohydrates",
          "protein",
          "fat",
          "fiber",
          "total_calories",
          "rating"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    # Add images to content
    if the_images.present?
      the_images.each do |uploaded_file|
        chat.user("Here's an image:", image: uploaded_file)
      end
    end

    # Add description text
    if the_description.present?
      chat.user("Here's the description of the meal: #{the_description}")
    end

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their target macros are #{current_user.target_calories} kcal, #{current_user.target_protein} g protein, #{current_user.target_fat} g fats, #{current_user.target_carbs} g carbohydrates, and #{current_user.target_fiber} g fiber.")

    result = chat.assistant!

    g_carbs = result.fetch("carbohydrates")
    g_protein = result.fetch("protein")
    g_fat = result.fetch("fat")
    g_fiber = result.fetch("fiber")
    kcal = result.fetch("total_calories")
    rating = result.fetch("rating")
    
        
    the_meal = Meal.new
    the_meal.date_consumed = Date.current
    the_meal.food_name = params.fetch("query_food_name")
    the_meal.meal_type = params.fetch("query_meal_type")
    the_meal.calories = kcal
    the_meal.protein = g_protein
    the_meal.fats = g_fat
    the_meal.carbs = g_carbs
    the_meal.fiber = g_fiber
    the_meal.user_id = current_user.id

    the_meal.rating = rating

    if the_meal.valid?
      the_meal.save
      redirect_to("/users/#{current_user.id}", { :notice => "Meal created successfully." })
    else
      redirect_to("/meals", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def manual_insert
    the_meal = Meal.new
    the_meal.date_consumed = params.fetch("query_date_consumed")
    the_meal.food_name = params.fetch("query_food_name")
    the_meal.meal_type = params.fetch("query_meal_type")
    the_meal.calories = params.fetch("query_calories")
    the_meal.protein = params.fetch("query_protein")
    the_meal.fats = params.fetch("query_fats")
    the_meal.carbs = params.fetch("query_carbs")
    the_meal.fiber = params.fetch("query_fiber")
    the_meal.user_id = params.fetch("query_user_id")

        the_images = params[:image_param]
    the_description = params.fetch("description_param", "")

    chat = OpenAI::Chat.new
    chat.model = 'o3-mini'
    chat.system("You are an expert nutritionist. Please give a rating on a scale of 1-10 how healthy the meal is given the macros provided and the user's goals.")
    chat.schema = '{
      "name": "nutrition_info",
      "schema": {
        "type": "object",
        "properties": {
            "rating": {
            "type": "integer",
            "description": "A rating on a scale of 1-10 how healthy the meal is."
          }
        },
        "required": [
          "rating"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    chat.user("The meal #{the_meal.food_name} had #{the_meal.calories} kcal, #{the_meal.protein} g protein, #{the_meal.fats} g fats, #{the_meal.carbs} g carbohydrates, and #{the_meal.fiber} g fiber.") 

    chat.user("The user's goals are #{current_user.primary_goal}, #{current_user.secondary_goal}, and #{current_user.tertiary_goal}. Their target macros are #{current_user.target_calories} kcal, #{current_user.target_protein} g protein, #{current_user.target_fat} g fats, #{current_user.target_carbs} g carbohydrates, and #{current_user.target_fiber} g fiber.") 

    result = chat.assistant!

    the_meal.rating = result.fetch("rating")

    if the_meal.valid?
      the_meal.save
      redirect_to("/users/#{current_user.id}", { :notice => "Meal created successfully." })
    else
      redirect_to("/meals", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("meal_id")
    the_meal = Meal.find_by(id: the_id)

    the_meal.date_consumed = params.fetch("query_date_consumed")
    the_meal.food_name = params.fetch("query_food_name")
    the_meal.rating = params.fetch("query_rating")
    the_meal.calories = params.fetch("query_calories")
    the_meal.protein = params.fetch("query_protein")
    the_meal.fats = params.fetch("query_fats")
    the_meal.carbs = params.fetch("query_carbs")
    the_meal.fiber = params.fetch("query_fiber")
    the_meal.meal_type = params.fetch("query_meal_type")

    user_id = current_user.id
    date = the_meal.date_consumed

    if the_meal.valid?
      the_meal.save
      redirect_to("/meals/#{date}/#{user_id}", { :notice => "Meal updated successfully."} )
    else
      redirect_to("/meals/#{date}/#{user_id}", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("meal_id")
    the_meal = Meal.find_by(id: the_id)

    user_id = current_user.id
    date = the_meal.date_consumed

    the_meal.destroy

    remaining = Meal.where({ :user_id => user_id, :date_consumed => date})
    if remaining.exists?
      redirect_to("/meals/#{date}/#{user_id}", { :notice => "Meal deleted successfully."} )
    else
      redirect_to "/meals"
    end
  end
end
