class Meal < ApplicationRecord
  belongs_to :user

  has_many :food_to_meals
  has_many :foods, through: :food_to_meals

  validates :category, inclusion: { in: %w[breakfast lunch dinner snack] }
  validates :served_on, timeliness: { on_or_before: lambda { Date.current }, type: :date }

end
