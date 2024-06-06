# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create(email: 'user1@example.com', password: 'p@ssw0rd', password_confirmation: 'p@ssw0rd')
User.create(email: 'user2@example.com', password: 'hogehoge', password_confirmation: 'hogehoge')

30.times do
  user_id = rand(1..2)
  title = Faker::Lorem.sentence
  content = Faker::Lorem.paragraph

  Post.create(user_id:, title:, content:)
end