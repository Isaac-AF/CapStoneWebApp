class CreateWorkoutSets < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_sets do |t|
      t.integer :set_number
      t.integer :workout_id
      t.integer :exercise_id
      t.integer :workout_reps_count

      t.timestamps
    end
  end
end
