class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :update, :destroy]
  def index
    render({ :template => "users/index" })
  end

  def show
    render({ :template => "users/show" })
  end

  def new
    render({ :template => "users/new_user" })
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

  def destroy
    the_id = params.fetch("path_id")
    the_user = user.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "user deleted successfully."} )
  end
end
