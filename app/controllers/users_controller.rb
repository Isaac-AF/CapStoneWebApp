class UsersController < ApplicationController
  def index
    render({ :template => "users/index" })
  end

  def show
    render({ :template => "users/show" })
  end

  def create
    the_user = user.new
    the_user.date_consumed = params.fetch("query_date_consumed")
    the_user.food_name = params.fetch("query_food_name")
    the_user.rating = params.fetch("query_rating")
    the_user.calories = params.fetch("query_calories")
    the_user.protein = params.fetch("query_protein")
    the_user.fats = params.fetch("query_fats")
    the_user.carbs = params.fetch("query_carbs")
    the_user.fiber = params.fetch("query_fiber")
    the_user.user_id = params.fetch("query_user_id")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "user created successfully." })
    else
      redirect_to("/users", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_user = user.where({ :id => the_id }).at(0)

    the_user.date_consumed = params.fetch("query_date_consumed")
    the_user.food_name = params.fetch("query_food_name")
    the_user.rating = params.fetch("query_rating")
    the_user.calories = params.fetch("query_calories")
    the_user.protein = params.fetch("query_protein")
    the_user.fats = params.fetch("query_fats")
    the_user.carbs = params.fetch("query_carbs")
    the_user.fiber = params.fetch("query_fiber")
    the_user.user_id = params.fetch("query_user_id")

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "user updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = user.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "user deleted successfully."} )
  end
end
