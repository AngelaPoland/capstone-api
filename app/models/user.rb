class User < ApplicationRecord
  has_many :intakes

  validates :email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, presence: true, numericality: { only_float: true, greater_than: 0 }

  def calculate_daily_goal
    user = User.find_by(id: self.user_id)

    age = user.age.to_i
    weight = user.weight.to_f
    x = weight / 2.2

    if age <= 30
      y = x * 40
    elsif age > 30 && age < 55
      y = x * 35
    elsif age >= 55
      y = x * 30
    end

    water_goal_in_oz = (y / 28.3).round

    return water_goal_in_oz
  end

  def daily_goal_in_cups
    (self.calculate_daily_goal / 8).round
  end

  def daily_goal_in_glasses
    (self.calculate_daily_goal / 16).round
  end





end
