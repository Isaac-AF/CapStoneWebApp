# == Schema Information
#
# Table name: meals
#
#  id            :bigint           not null, primary key
#  calories      :float
#  carbs         :float
#  date_consumed :date
#  fats          :float
#  fiber         :float
#  food_name     :string
#  meal_type     :string
#  protein       :float
#  rating        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#
class Meal < ApplicationRecord
  validates(:food_name, presence: true)
  validates(:user_id, presence: true)

  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id", counter_cache: true
end
