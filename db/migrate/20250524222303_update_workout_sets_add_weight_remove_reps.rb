class UpdateWorkoutSetsAddWeightRemoveReps < ActiveRecord::Migration[6.1] # or your version
  def change
    add_column :workout_sets, :weight, :decimal
  end
end
