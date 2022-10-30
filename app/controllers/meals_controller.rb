class MealsController < ApplicationController
  before_action :set_meal, only: %i[ show update destroy ]

  # GET /meals
  def index
    if params[:date].present?
      @meals = current_user.meals.on_date(params[:date])
    else
      @meals = current_user.meals
    end

    render json: @meals
  end

  # GET /meals/1
  def show
    render json: @meal
  end

  # POST /meals
  def create
    @meal = current_user.meals.build(meal_params)

    if @meal.save
      render json: @meal, status: :ok, location: @meal
    else
      render json: @meal.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meals/1
  def update
    if @meal.update(meal_params)
      render json: @meal
    else
      render json: @meal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /meals/1
  def destroy
    @meal.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meal_params
      params.permit(:category, :served_on)
    end
end