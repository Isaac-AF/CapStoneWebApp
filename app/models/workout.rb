# == Schema Information
#
# Table name: workouts
#
#  id                 :bigint           not null, primary key
#  workout_datetime   :datetime
#  workout_sets_count :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
class Workout < ApplicationRecord
  validates(:user_id, presence: true)

  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id", counter_cache: true
  has_many  :workout_sets, class_name: "WorkoutSet", foreign_key: "workout_id", dependent: :destroy
end
