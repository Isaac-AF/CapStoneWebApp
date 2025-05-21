class AddMealTypeToMeals < ActiveRecord::Migration[7.1]
  def change
    add_column :meals, :meal_type, :string
  end
end
