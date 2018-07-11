class User < ApplicationRecord
  has_many :intakes

  validates :email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, presence: true, numericality: { only_float: true, greater_than: 0 }

  def calculate_daily_goal
    # user = User.find_by(id: self.user_id)

    age = self.age.to_i
    weight = self.weight.to_f
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
    (self.calculate_daily_goal / 8).round(1)
  end

  def daily_goal_in_glasses
    (self.calculate_daily_goal / 16).round(1)
  end

  def total_drank_today
    total = 0.0

    self.intakes.each do |intake|
      if intake.created_at.strftime("%Y-%m-%d") == Date.today.strftime("%Y-%m-%d")
       total += intake.amount  #amount is currently in oz
      end
    end
    return total
  end

  def percent_to_goal
    num = ((self.total_drank_today / self.calculate_daily_goal).round(4) * 100)
    return "#{num}%"
  end

  def total_left_to_drink # in OZ
    (self.calculate_daily_goal - self.total_drank_today)
  end


  def total_drank_week
    intake_log = []
    week_hash = {}
    week_log = []

    self.intakes.each do |intake|
      if ((Date.today - 7)..(Date.today + 1)).cover?(intake.created_at)
        intake_log << intake
      end
    end

    intake_log.each do |intake|
      if week_hash[intake.created_at]
        week_hash[intake.created_at] += intake.amount
      else
        week_hash[intake.created_at] = intake.amount
      end
    end

    week_log = week_hash.values  #this returns an array of each day's total amount drank

  end

  def total_drank_month
    intake_log = []
    month_hash = {}
    month_log = []

    self.intakes.each do |intake|
      if ((Date.today - 7)..(Date.today + 1)).cover?(intake.created_at)
        intake_log << intake
      end
    end

    intake_log.each do |intake|
      if month_hash[intake.created_at]
        month_hash[intake.created_at] += intake.amount
      else
        month_hash[intake.created_at] = intake.amount
      end
    end

    month_log = month_hash.values  #this returns an array of each day's total amount drank

  end





end
