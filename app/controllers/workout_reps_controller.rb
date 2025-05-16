class WorkoutRepsController < ApplicationController
  def index
    matching_workout_reps = WorkoutRep.all

    @list_of_workout_reps = matching_workout_reps.order({ :created_at => :desc })

    render({ :template => "workout_reps/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_workout_reps = WorkoutRep.where({ :id => the_id })

    @the_workout_rep = matching_workout_reps.at(0)

    render({ :template => "workout_reps/show" })
  end

  def create
    the_workout_rep = WorkoutRep.new
    the_workout_rep.weight = params.fetch("query_weight")
    the_workout_rep.reps = params.fetch("query_reps")
    the_workout_rep.set_id = params.fetch("query_set_id")

    if the_workout_rep.valid?
      the_workout_rep.save
      redirect_to("/workout_reps", { :notice => "Workout rep created successfully." })
    else
      redirect_to("/workout_reps", { :alert => the_workout_rep.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_workout_rep = WorkoutRep.where({ :id => the_id }).at(0)

    the_workout_rep.weight = params.fetch("query_weight")
    the_workout_rep.reps = params.fetch("query_reps")
    the_workout_rep.set_id = params.fetch("query_set_id")

    if the_workout_rep.valid?
      the_workout_rep.save
      redirect_to("/workout_reps/#{the_workout_rep.id}", { :notice => "Workout rep updated successfully."} )
    else
      redirect_to("/workout_reps/#{the_workout_rep.id}", { :alert => the_workout_rep.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_workout_rep = WorkoutRep.where({ :id => the_id }).at(0)

    the_workout_rep.destroy

    redirect_to("/workout_reps", { :notice => "Workout rep deleted successfully."} )
  end
end
