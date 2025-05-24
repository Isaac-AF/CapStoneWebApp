class DropWorkoutRepsTable < ActiveRecord::Migration[6.1] # or your Rails version
  def change
    drop_table :workout_reps
  end
end
