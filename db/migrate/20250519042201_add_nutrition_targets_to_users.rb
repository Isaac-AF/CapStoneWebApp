class AddNutritionTargetsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :target_calories, :integer
    add_column :users, :target_protein, :integer
    add_column :users, :target_carbs, :integer
    add_column :users, :target_fat, :integer
    add_column :users, :target_fiber, :integer
  end
end
