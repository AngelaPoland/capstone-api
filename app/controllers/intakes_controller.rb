class IntakesController < ApplicationController
  def new
    @intake = Intake.new
  end

  def create
    @intake = Intake.new(intake_params)
  end

  def index
    @intakes = Intake.all

  end

  def show
      @intake = Intake.find_by(id: params[:id])
      render json: @intake.as_json(only: [:date, :amount])
  end

  private
  def intake_params
    params.require(:intake).permit(:date, :amount)
  end
end
