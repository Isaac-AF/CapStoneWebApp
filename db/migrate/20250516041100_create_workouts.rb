class CreateWorkouts < ActiveRecord::Migration[7.1]
  def change
    create_table :workouts do |t|
      t.datetime :workout_datetime
      t.integer :user_id
      t.integer :workout_sets_count

      t.timestamps
    end
  end
end
