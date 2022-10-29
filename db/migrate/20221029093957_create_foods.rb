class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.numeric :calories
      t.numeric :carbs
      t.numeric :fat
      t.numeric :protein

      t.timestamps
    end
  end
end
