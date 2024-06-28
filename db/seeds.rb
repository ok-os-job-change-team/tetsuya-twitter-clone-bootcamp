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
USERS_COUNT = 2
POST_BATCH_SIZE = 1_000
TOTAL_POST_COUNT = 10_000

Faker::Config.random = Random.new(1)

users = []
USERS_COUNT.times do |i|
  email = "user#{i + 1}@example.com"
  password = 'p@ssw0rd'
  password_confirmation = 'p@ssw0rd'

  users << User.new(email:, password:, password_confirmation:)
end

User.import users

posts = []
TOTAL_POST_COUNT.times do |i|
  user_id = i % USERS_COUNT + 1
  title = Faker::Lorem.sentence
  content = Faker::Lorem.paragraph

  posts << Post.new(user_id:, title:, content:)

  if posts.size >= POST_BATCH_SIZE
    Post.import(posts)
    posts.clear
  end
end

Post.import(posts) unless posts.empty?
