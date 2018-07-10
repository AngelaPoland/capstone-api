class UsersController < ApplicationController
  def new
  end

  def index
    @users = User.all
  end

  def create
    user = User.create(user_params)

    if user.valid?
      ##  when a new user is created, corresponding daily_goal is calculated
      daily_goal = user.calculate_daily_goal
      render json: {id: user.id, goal: daily_goal}, status: :ok
    else
      render json: {ok: false, errors: user.errors}, status: :bad_request
    end
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user
      render json: @user.as_json(only: [:name, :age, :weight, :goal])
    else
      render json: {ok: false, :errors => "User not found"}, status: :not_found
    end
  end

  def update
  end

  private
    def user_params
      params.permit(:name, :age, :weight)
    end



end
