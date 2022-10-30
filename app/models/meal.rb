class Meal < ApplicationRecord
  belongs_to :user

  has_many :food_to_meals
  has_many :foods, through: :food_to_meals

  validates :category, inclusion: { in: %w[breakfast lunch dinner snack] }
  validates :served_on, timeliness: { on_or_before: lambda { Date.current }, type: :date }

  scope :on_date, -> (date) { where(served_on: date) }

  def foods_with_nutritional_values
    food_to_meals.map do |fm|
      factor = fm.serving_size / 100
      {
        id: fm.food.id,
        name: fm.food.name,
        calories: (fm.food.calories * factor).round(2),
        fat: (fm.food.fat * factor).round(2),
        protein: (fm.food.protein * factor).round(2),
        carbs: (fm.food.carbs * factor).round(2)
      }
    end
  end

  def total_calories
    food_to_meals.inject(0) do |sum, fm|
      sum += (fm.food.calories * (fm.serving_size / 100)).round(2)
    end
  end
end
