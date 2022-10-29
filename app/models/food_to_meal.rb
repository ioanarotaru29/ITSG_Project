class FoodToMeal < ApplicationRecord
  belongs_to :meal
  belongs_to :food

  validates :serving_size, numericality: true, presence: true
end
