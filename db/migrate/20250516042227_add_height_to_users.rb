class AddHeightToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :height, :decimal
  end
end
