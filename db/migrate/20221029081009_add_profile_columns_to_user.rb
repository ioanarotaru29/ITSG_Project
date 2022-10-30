class AddProfileColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_column :users, :gender, :string, default: 'M'
    add_column :users, :activity_type, :string, default: 'active'
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :date_of_birth, :date

    add_column :users, :active_metabolic_rate, :float

    add_index :users, [:first_name, :last_name], unique: true
  end
end
