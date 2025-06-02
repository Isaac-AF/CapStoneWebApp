class WorkoutSetsController < ApplicationController
  def index
    @list_of_workout_sets = WorkoutSet.where(workout_id: params[:workout_id]).includes(:exercise)

    render({ :template => "workout_sets/index" })
  end

  def show
    the_id = params.fetch("set_id")

    matching_workout_sets = WorkoutSet.where({ :id => the_id })

    @the_workout_set = matching_workout_sets.at(0)

    render({ :template => "workout_sets/show" })
  end

  def create
    the_workout_set = WorkoutSet.new
    the_workout_set.workout_id = params.fetch("query_workout_id")
    the_workout_set.exercise_id = params.fetch("query_exercise_id")
    the_workout_set.set_number = params.fetch("query_workout_set_number")
    the_workout_set.workout_reps_count = params.fetch("query_workout_reps_count")
    the_workout_set.weight = params.fetch("query_weight")

    if the_workout_set.valid?
      the_workout_set.save

      matching_workout_sets = WorkoutSet.where(workout_id: params.fetch("query_workout_id"))
      @list_of_workout_sets = matching_workout_sets.order({ :created_at => :desc })

      redirect_to("/workout_sets/#{the_workout_set.workout_id}", { :notice => "Workout set created successfully." })
    else
      redirect_to("/workout_sets/#{the_workout_set.workout_id}", { :alert => the_workout_set.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("set_id")
    the_workout_set = WorkoutSet.where({ :id => the_id }).at(0)

    the_workout_set.set_number = params.fetch("query_set_number")
    the_workout_set.workout_id = params.fetch("query_workout_id")
    the_workout_set.exercise_id = params.fetch("query_exercise_id")
    the_workout_set.workout_reps_count = params.fetch("query_workout_reps_count")
    the_workout_set.weight = params.fetch("query_workout_weight")

    if the_workout_set.valid?
      the_workout_set.save
      redirect_to("/workout_sets/#{the_workout_set.workout_id}", { :notice => "Workout set updated successfully."} )
    else
      redirect_to("/workout_sets/#{the_workout_set.workout_id}", { :alert => the_workout_set.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("set_id")
    the_workout_set = WorkoutSet.where({ :id => the_id }).at(0)

    the_workout_set.destroy

    redirect_to("/workout_sets/#{the_workout_set.workout_id}", { :notice => "Workout set deleted successfully."} )
  end
end
