class WorkoutSetsController < ApplicationController
  def index
    @list_of_workout_sets = WorkoutSet.includes(:exercise).where(workout_id: params[:workout_id])

      workout_id = params[:workout_id]
      @workout = Workout.find(params[:workout_id])

      # Find the last workout_set for this workout
      last_set = WorkoutSet.where(workout_id: workout_id).order(created_at: :desc).first
      @last_exercise_id = last_set&.exercise_id

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

  def next_set_number
    workout_id = params[:workout_id]
    exercise_id = params[:exercise_id]

    existing_set_numbers = WorkoutSet.where(workout_id: workout_id, exercise_id: exercise_id).pluck(:set_number)

    next_set_number = existing_set_numbers.empty? ? 1 : existing_set_numbers.max + 1

    render json: {next_set_number: next_set_number}
  end

  def recent_sets
    user_id            = params.require(:user_id)
    exercise_id        = params.require(:exercise_id)
    exclude_workout_id = params[:exclude_workout_id].presence

    order_expr = "MAX(COALESCE(workouts.workout_datetime, workouts.created_at))"

    base = Workout
            .joins(:workout_sets)
            .where(user_id: user_id, workout_sets: { exercise_id: exercise_id })
    base = base.where.not(id: exclude_workout_id) if exclude_workout_id

    last_workout_id = base
      .group("workouts.id")
      .order(Arel.sql("#{order_expr} DESC"))
      .limit(1)
      .pluck("workouts.id")
      .first

    if last_workout_id.nil?
      render json: { date: nil, sets: [] } and return
    end

    effective_dt = Workout.where(id: last_workout_id)
      .pick(Arel.sql("COALESCE(workouts.workout_datetime, workouts.created_at)"))

    sets = WorkoutSet
            .where(workout_id: last_workout_id, exercise_id: exercise_id)
            .order(:set_number)
            .pluck(:set_number, :workout_reps_count, :weight)

    render json: {
      date: effective_dt&.to_date,
      sets: sets.map { |set_number, reps, weight|
        { set_number: set_number, reps: reps, weight: weight }
      }
    }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  end

end
