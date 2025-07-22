class AddIndexesToWorkoutSetsAndExercises < ActiveRecord::Migration[7.1]
  def change
    add_index :workout_sets, :workout_id
    add_index :workout_sets, :exercise_id
    add_index :exercises, :exercise_name
  end
end
