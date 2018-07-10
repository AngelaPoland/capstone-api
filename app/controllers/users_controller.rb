class UsersController < ApplicationController

  def index
    @users = User.all
    render json: @users.as_json
  end

  def create
    user = User.create(user_params)

    if user.valid?
      ##  when a new user is created, corresponding daily_goal is calculated

      render json: {id: user.id, name: user.name, email: user.email, age: user.age, weight: user.weight}, status: :ok
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
  end

  def goal  # you can route directly to a model method (so one API call per method needed)
    @user = User.find_by(id: params[:id])

    amount = @user.calculate_daily_goal
    amount_in_cups = @user.daily_goal_in_cups
    amount_in_glasses = @user.daily_goal_in_glasses
    amount_towards_goal = @user.total_drank_today

    render json: {id: @user.id, goal: amount, goal_in_cups: amount_in_cups, goal_in_glasses: amount_in_glasses, percent_drank_towards_goal: amount_towards_goal}, status: :ok   # deal with this later
  end

  private
    def user_params
      params.permit(:name, :age, :weight)
    end



end
