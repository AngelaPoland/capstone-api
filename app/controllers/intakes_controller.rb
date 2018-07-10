class IntakesController < ApplicationController


  def create
    intake = Intake.new(intake_params)
    if intake.valid?
      intake.save
      render json: {id: intake.id}, status: :ok
    else
      render json: {ok: false, errors: intake.errors}, status: :bad_request
    end
  end

  def index
    @intakes = Intake.all
    render json: @intakes.as_json

  end

  def show
    intake = Intake.find_by(id: params[:id])

    if intake
      render json: intake.as_json, status: :ok
    else
      render json: { ok: false, errors: {id: ["Intake not found"]} }, status: :not_found
    end
    # render json: @intake.as_json(only: [:created_at, :amount])
  end

  private
  def intake_params
    params.require(:intake).permit(:amount, :user_id)
  end
end
