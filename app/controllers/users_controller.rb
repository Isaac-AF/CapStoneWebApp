class UsersController < ApplicationController
  def index
    render({ :template => "users/index" })
  end

  def show
    render({ :template => "users/show" })
  end

  def new
    render({ :template => "users/new_user" })
  end

  def validate
    the_user = User.find_by(email: params.fetch("query_email"))
    if the_user&.valid_password?(params.fetch("query_password"))
      redirect_to("/user/:path_id", { :notice => "Login success." })
    else
      redirect_to("/", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def create
    the_user = User.new
    the_user.name = params.fetch("query_name")
    the_user.email = params.fetch("query_email")
    #Need to hash the password eventually
    the_user.password = params.fetch("query_password")
    the_user.password_confirmation = params.fetch("query_password")
    the_user.birthday = params.fetch("query_birthday")
    the_user.sex = params.fetch("query_gender")
    the_user.height = params.fetch("query_height")
    the_user.weight = params.fetch("query_weight")
    the_user.activity_level = params.fetch("query_activity_level")
    the_user.primary_goal = params.fetch("query_primary_goal")
    the_user.secondary_goal = params.fetch("query_secondary_goal")

    if the_user.valid?
      the_user.save
      redirect_to("/user/:path_id", { :notice => "User created successfully." })
    else
      redirect_to("/new_user", { :alert => the_user.errors.full_messages.to_sentence })
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
