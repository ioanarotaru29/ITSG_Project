class MealsController < ApplicationController
  include HTTParty

  BASE_AI_URL = 'http://localhost:5000/predict'
  before_action :set_meal, only: %i[ show update destroy ]

  # GET /meals
  def index
    if params[:date].present?
      @meals = current_user.meals.on_date(params[:date])
    else
      @meals = current_user.meals
    end
    response_data = []
    @meals.each do |meal|
      meal_hash = {
        id: meal.id,
        category: meal.category,
        served_on: meal.served_on,
        foods: meal.foods_with_nutritional_values,
        calories: meal.total_calories,
        photo: meal.photo&.url || ""
      }
      response_data << meal_hash
    end

    render json: response_data
  end

  # GET /meals/1
  def show
    response_data = {
      id: @meal.id,
      category: @meal.category,
      served_on: @meal.served_on,
      foods: @meal.foods_with_nutritional_values,
      calories: @meal.total_calories
    }

    render json: response_data
  end

  # POST /meals
  def create
    binding.pry
    @meal = current_user.meals.build(meal_params)
    if @meal.save
      # binding.pry
      # response = HTTParty.post(BASE_AI_URL, body: {url: @meal.photo.url}.to_json, headers: { 'Content-Type' => 'application/json' }) if @meal.photo.present?
      render json: {
        id: @meal.id,
        category: @meal.category,
        served_on: @meal.served_on,
        foods: @meal.foods_with_nutritional_values,
        calories: @meal.total_calories,
        photo: @meal.photo.url || ""
      }, status: :ok, location: @meal
    else
      render json: @meal.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meals/1
  def update
    if @meal.update(meal_params)
      render json: {
        id: @meal.id,
        category: @meal.category,
        served_on: @meal.served_on,
        foods: @meal.foods_with_nutritional_values,
        calories: @meal.total_calories,
        photo: @meal.photo.url || ""
      }
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
      params.permit(:category, :served_on, :photo, food_to_meals_attributes: [:id, :food_id, :serving_size, :_destroy])
    end
end
