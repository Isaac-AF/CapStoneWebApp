class MealsController < ApplicationController
  def index
    matching_meals = Meal.all

    @list_of_meals = matching_meals.order({ :created_at => :desc })

    render({ :template => "meals/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_meals = Meal.where({ :id => the_id })

    @the_meal = matching_meals.at(0)

    render({ :template => "meals/show" })
  end

  def interpret
    the_images = params[:image_param]
    the_description = params.fetch("description_param", "")

    chat = OpenAI::Chat.new
    chat.model = 'o3'
    chat.system("You are an expert nutritionist. Your job is to estimate how many grams of carbohydrates, grams of protein, grams of fat, grams of fiber, and total calories are in a meal. The user will provide either a photo or two, a description, or both. The photo may be an image of the food itself, a recipe that was used to prepare the food, a picture of a menu, or a barcode that should be used to look up the nutrition facts of the item. Please also give a rating on a scale of 1-10 how healthy the meal is given the macros provided and the user's goals.")
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
    the_meal.calories = kcal
    the_meal.protein = g_protein
    the_meal.fats = g_fat
    the_meal.carbs = g_carbs
    the_meal.fiber = g_fiber
    the_meal.user_id = current_user.id

    the_meal.rating = rating

    if the_meal.valid?
      the_meal.save
      redirect_to("/meals", { :notice => "Meal created successfully." })
    else
      redirect_to("/meals", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def insert
    the_meal = Meal.new
    the_meal.date_consumed = params.fetch("query_date_consumed")
    the_meal.food_name = params.fetch("query_food_name")
    the_meal.calories = params.fetch("query_calories")
    the_meal.protein = params.fetch("query_protein")
    the_meal.fats = params.fetch("query_fats")
    the_meal.carbs = params.fetch("query_carbs")
    the_meal.fiber = params.fetch("query_fiber")
    the_meal.user_id = params.fetch("query_user_id")

    the_meal.rating = params.fetch("query_rating")

    if the_meal.valid?
      the_meal.save
      redirect_to("/meals", { :notice => "Meal created successfully." })
    else
      redirect_to("/meals", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_meal = Meal.where({ :id => the_id }).at(0)

    the_meal.date_consumed = params.fetch("query_date_consumed")
    the_meal.food_name = params.fetch("query_food_name")
    the_meal.rating = params.fetch("query_rating")
    the_meal.calories = params.fetch("query_calories")
    the_meal.protein = params.fetch("query_protein")
    the_meal.fats = params.fetch("query_fats")
    the_meal.carbs = params.fetch("query_carbs")
    the_meal.fiber = params.fetch("query_fiber")
    the_meal.user_id = params.fetch("query_user_id")

    if the_meal.valid?
      the_meal.save
      redirect_to("/meals/#{the_meal.id}", { :notice => "Meal updated successfully."} )
    else
      redirect_to("/meals/#{the_meal.id}", { :alert => the_meal.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_meal = Meal.where({ :id => the_id }).at(0)

    the_meal.destroy

    redirect_to("/meals", { :notice => "Meal deleted successfully."} )
  end
end
