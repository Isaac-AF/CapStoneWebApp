# == Schema Information
#
# Table name: workout_sets
#
#  id                 :bigint           not null, primary key
#  set_number         :integer
#  weight             :decimal(, )
#  workout_reps_count :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  exercise_id        :integer
#  workout_id         :integer
#
# Indexes
#
#  index_workout_sets_on_exercise_id  (exercise_id)
#  index_workout_sets_on_workout_id   (workout_id)
#
class WorkoutSet < ApplicationRecord
  validates(:exercise_id, presence: true)
  validates(:workout_id, presence: true)
  validates(:set_number, presence: true)

  belongs_to :workout, required: true, class_name: "Workout", foreign_key: "workout_id"
  belongs_to :exercise, required: true, class_name: "Exercise", foreign_key: "exercise_id"
  has_one  :user, through: :workout, source: :user
end
