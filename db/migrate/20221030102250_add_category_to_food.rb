class AddCategoryToFood < ActiveRecord::Migration[7.0]
  def change
    add_column :foods, :category, :string
  end
end
