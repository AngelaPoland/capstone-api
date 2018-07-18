class User < ApplicationRecord
  has_many :intakes

  validates :email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, presence: true, numericality: { only_float: true, greater_than: 0 }

  def calculate_daily_goal
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
      if intake.created_at.strftime("%Y-%m-%d") === Date.today.strftime("%Y-%m-%d")
       total += intake.amount  #amount is currently in oz
      end
    end
    return total
  end

  def percent_to_goal
    num = ((self.total_drank_today / self.goal) * 100).round(2)
    return num
  end

  def total_left_to_drink # in OZ
    (self.goal - self.total_drank_today)
  end


  def total_drank_week
    intake_log = []
    week_hash = {}

    first_date = Date.today - 6
    last_date = Date.today
    range = (first_date..last_date)

    self.intakes.sort_by { |intake| intake.created_at }.each do |intake|
      if range.include?(intake.created_at.to_date)
        intake_log << intake
      end
    end

    intake_log.each do |intake|
      if week_hash[intake.created_at.to_date]
        week_hash[intake.created_at.to_date] += intake.amount
      else
        week_hash[intake.created_at.to_date] = 0
      end
    end

    week_log = week_hash.values  #this returns an array of each day's total amount drank in oz
    # return week_log
    return week_hash
  end

  def total_drank_month
    intake_log = []
    month_hash = {}

    first_date = Date.today - 30
    last_date = Date.today
    range = (first_date..last_date)

    puts range
    puts intake_log.each do |intake|
      intake.created_at.to_date
    end

    self.intakes.sort_by { |intake| intake.created_at }.each do |intake|
      if range.include?(intake.created_at.to_date)
        intake_log << intake
      end
    end

    intake_log.each do |intake|
      if month_hash[intake.created_at.to_date]
        month_hash[intake.created_at.to_date] += intake.amount
      else
        month_hash[intake.created_at.to_date] = 0
      end
    end

    month_log = month_hash.values  #this returns an array of each day's total amount drank in oz
    # return month_log
    return month_hash
  end





end
