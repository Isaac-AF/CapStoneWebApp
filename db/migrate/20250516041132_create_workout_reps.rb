class CreateWorkoutReps < ActiveRecord::Migration[7.1]
  def change
    create_table :workout_reps do |t|
      t.float :weight
      t.integer :reps
      t.integer :set_id

      t.timestamps
    end
  end
end
