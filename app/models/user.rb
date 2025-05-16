# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  activity_level         :string
#  birthday               :date
#  dietary_restrictions   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  height                 :decimal(, )
#  meals_count            :integer
#  name                   :string
#  primary_goal           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  secondary_goal         :string
#  sex                    :string
#  tertiary_goal          :string
#  weight                 :decimal(, )
#  workouts_count         :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates(:email, presence: true)
  validates(:password, presence: true)
  validates(:name, presence: true)
  validates(:sex, presence: true)
  validates(:height, presence: true)
  validates(:weight, presence: true)
  validates(:activity_level, presence: true)
  validates(:primary_goal, presence: true)

  has_many  :meals, class_name: "Meal", foreign_key: "user_id", dependent: :destroy
  has_many  :workouts, class_name: "Workout", foreign_key: "user_id", dependent: :destroy
  has_many :workout_sets, through: :workouts, source: :workout_sets
  has_many :workout_reps, through: :workout_sets, source: :workout_reps

end
