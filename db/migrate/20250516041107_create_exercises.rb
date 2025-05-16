class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises do |t|
      t.string :exercise_name
      t.string :primary_muscle
      t.string :secondary_muscle
      t.string :tertiary_muscle

      t.timestamps
    end
  end
end
