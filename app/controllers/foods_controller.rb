class FoodsController < ApplicationController
  before_action :set_food, only: %i[show]

  # GET /foods
  def index
    return if params[:category].blank? && params[:name].blank?

    @foods = Food
    if params[:category].present?
      @foods = @foods.where(category: params[:category])
    end
    if params[:name].present?
      @foods = @foods.where('name like ?', "%#{params[:name]}%")
    end
    render json: @foods
  end

  # GET /foods/1
  def show
    render json: @food
  end

  def categories
    render json: Food.pluck(:category).uniq.compact
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_food
    @food = food.find(params[:id])
  end
end
