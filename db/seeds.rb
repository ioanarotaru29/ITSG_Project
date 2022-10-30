# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'csv'

#Doorkeeper Setup
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "FrontEnd App", redirect_uri: "", scopes: "")
end

#Foods Setup
csv_text = File.read(Rails.root.join('lib', 'seeds', 'food_data.csv'))
csv = CSV.parse(csv_text, headers: true, col_sep: ';')
csv.each do |row|
  Food.create!(name: row["Name"],
               category: row["Category"] == "NULL" ? nil : row["Category"],
               calories: row["Calories"].gsub(',','.').to_f,
               fat: row["Fat"].gsub(',','.').to_f,
               protein: row["Protein"].gsub(',','.').to_f,
               carbs: row["Carbs"].gsub(',','.').to_f)
end