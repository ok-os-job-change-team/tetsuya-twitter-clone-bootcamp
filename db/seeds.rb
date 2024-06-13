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

Post.create(user_id: 1, title: 'タイトル1-1', content: '本文1-1')
Post.create(user_id: 1, title: 'タイトル1-2', content: '本文1-2')
Post.create(user_id: 1, title: 'タイトル1-3', content: '本文1-3')
Post.create(user_id: 2, title: 'タイトル2-1', content: '本文2-1')
Post.create(user_id: 2, title: 'タイトル2-2', content: '本文2-2')
Post.create(user_id: 2, title: 'タイトル2-3', content: '本文2-3')
