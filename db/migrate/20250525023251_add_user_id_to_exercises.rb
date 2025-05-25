class AddUserIdToExercises < ActiveRecord::Migration[7.1]
  def change
    add_column :exercises, :user_id, :integer
  end
end
