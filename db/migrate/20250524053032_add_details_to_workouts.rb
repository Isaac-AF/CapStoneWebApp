class AddDetailsToWorkouts < ActiveRecord::Migration[7.1]
  def change
    add_column :workouts, :workout_type, :string
    add_column :workouts, :calories_burned, :decimal
  end
end
