class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.date :date_consumed
      t.string :food_name
      t.string :rating
      t.float :calories
      t.float :protein
      t.float :fats
      t.float :carbs
      t.float :fiber
      t.integer :user_id

      t.timestamps
    end
  end
end
