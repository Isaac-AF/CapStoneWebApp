class UpdateWorkoutsAddRatingRemoveSetsCount < ActiveRecord::Migration[7.1]
  def change
    add_column :workouts, :rating, :integer
    remove_column :workouts, :workout_sets_count, :integer
  end
end
