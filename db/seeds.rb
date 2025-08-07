# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default frames and circles for testing purposes

# if Rails.env.development?
#   Frame.find_or_create_by!(center_x: 10.0, center_y: 10.0, width: 10.0, height: 10.0) do |frame|
#     frame.circles.create!(center_x: 2.0, center_y: 2.0, radius: 1.0)
#     frame.circles.create!(center_x: 8.0, center_y: 8.0, radius: 2.0)
#   end

#   Frame.find_or_create_by!(center_x: 20.0, center_y: 20.0, width: 5.0, height: 5.0)
# end
