# == Schema Information
#
# Table name: workout_sets
#
#  id                 :bigint           not null, primary key
#  set_number         :integer
#  workout_reps_count :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  exercise_id        :integer
#  workout_id         :integer
#
class WorkoutSet < ApplicationRecord
  validates(:exercise_id, presence: true)
  validates(:workout_id, presence: true)
  validates(:set_number, presence: true)

  belongs_to :workout, required: true, class_name: "Workout", foreign_key: "workout_id", counter_cache: true
  belongs_to :exercise, required: true, class_name: "Exercise", foreign_key: "exercise_id"
  has_many  :workout_reps, class_name: "WorkoutRep", foreign_key: "set_id", dependent: :destroy
  has_one  :user, through: :workout, source: :user
end
