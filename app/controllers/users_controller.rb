class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
    render json: @users.as_json
  end

  def create
    user = User.create(user_params)

    if user.valid?
      ##  when a new user is created, corresponding daily_goal is calculated
      user.goal = user.calculate_daily_goal
      user.save!

      render json: {id: user.id, name: user.name, email: user.email, age: user.age, weight: user.weight, goal: user.goal}, status: :ok
    else
      render json: {ok: false, errors: user.errors}, status: :bad_request
    end
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user
      render json: @user.as_json(only: [:name, :age, :weight, :goal, :email])
    else
      render json: {ok: false, :errors => "User not found"}, status: :not_found
    end
  end

  def update
    #HOW TO EDIT A USER
    logger.debug "Updating User with #{params}"
    user = User.find_by(id: params[:id])
    if !user.nil?
      if user.update(user_params)
        user.save
        render :json => user.as_json(only: [:name, :email, :age, :weight, :goal]), status: :ok
      else
        render json: {ok: false, errors: user.errors}, status: :bad_request
      end
    else
      render json: {ok: false, errors: "User does not exist."}, status: :not_found
    end
  end

  def goal  # you can route directly to a model method (so one API call per method needed)
    @user = User.find_by(id: params[:id])

    amount = @user.goal
    amount_in_cups = @user.daily_goal_in_cups
    amount_in_glasses = @user.daily_goal_in_glasses
    amount_today = @user.total_drank_today
    amount_towards_goal = @user.percent_to_goal
    week = @user.total_drank_week
    month = @user.total_drank_month
    left_to_go = @user.total_left_to_drink

    render json: {id: @user.id, goal: amount, goal_in_cups: amount_in_cups, goal_in_glasses: amount_in_glasses, amount_drank_today: amount_today, percent_drank_towards_goal: amount_towards_goal, total_for_week: week, total_drank_month: month, left_to_drink: left_to_go}, status: :ok
  end

  private
    def user_params
      params.permit(:name, :age, :weight, :email, )
    end



end
