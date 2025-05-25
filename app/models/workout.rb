# == Schema Information
#
# Table name: workouts
#
#  id               :bigint           not null, primary key
#  calories_burned  :decimal(, )
#  rating           :integer
#  workout_datetime :datetime
#  workout_type     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
class Workout < ApplicationRecord
  validates(:user_id, presence: true)
  validates(:workout_type, presence: true)
  validates(:workout_datetime, presence: true)

  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id", counter_cache: true
  has_many  :workout_sets, class_name: "WorkoutSet", foreign_key: "workout_id", dependent: :destroy
end
