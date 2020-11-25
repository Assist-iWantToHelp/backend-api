# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

puts "Importing categories ..."

filename = File.join(Rails.root, "/db/", "categories.csv")
CSV.foreach(filename, :headers => true) do |row|
  Category.where(name: row['name']).first_or_create!(row.to_hash)
end

puts "Categories imported!"
