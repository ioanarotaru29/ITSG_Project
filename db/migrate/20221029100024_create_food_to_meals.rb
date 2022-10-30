class CreateFoodToMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :food_to_meals do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.float :serving_size, null: false

      t.timestamps
    end
  end
end
