class FoodsController < ApplicationController
  before_action :set_food, only: %i[show]

  # GET /foods
  def index
    @foods = Food.all
    render json: @foods
  end

  # GET /foods/1
  def show
    render json: @food
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = food.find(params[:id])
  end
end
