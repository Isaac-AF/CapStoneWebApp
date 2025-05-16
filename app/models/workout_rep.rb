# == Schema Information
#
# Table name: workout_reps
#
#  id         :bigint           not null, primary key
#  reps       :integer
#  weight     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  set_id     :integer
#
class WorkoutRep < ApplicationRecord
  validates(:set_id, presence: true)
  validates(:weight, presence: true)
  validates(:reps, presence: true)

  belongs_to :set, required: true, class_name: "WorkoutSet", foreign_key: "set_id", counter_cache: true
  has_one  :user, through: :set, source: :user
end
