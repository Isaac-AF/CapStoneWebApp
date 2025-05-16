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

  def create
    the_meal = Meal.new
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
