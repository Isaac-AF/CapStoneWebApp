# == Schema Information
#
# Table name: exercises
#
#  id               :bigint           not null, primary key
#  exercise_name    :string
#  primary_muscle   :string
#  secondary_muscle :string
#  tertiary_muscle  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
class Exercise < ApplicationRecord
  validates(:exercise_name, presence: true)

  has_many  :workout_sets, class_name: "WorkoutSet", foreign_key: "exercise_id", dependent: :destroy
end
