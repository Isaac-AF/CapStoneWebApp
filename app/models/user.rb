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
#  height                 :float
#  meals_count            :integer
#  name                   :string
#  primary_goal           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  secondary_goal         :string
#  sex                    :string
#  target_calories        :integer
#  target_carbs           :integer
#  target_fat             :integer
#  target_fiber           :integer
#  target_protein         :integer
#  tertiary_goal          :string
#  weight                 :float
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
end
