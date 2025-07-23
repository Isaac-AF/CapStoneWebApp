class AddIndexesToMeals < ActiveRecord::Migration[7.0] # or your Rails version
  def change
    add_index :meals, :user_id
    add_index :meals, :date_consumed
    add_index :meals, [:user_id, :date_consumed]  # composite index for optimal query
  end
end
