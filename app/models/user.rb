# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  has_secure_password

  def favorited?(post)
    favorites.exists?(post:)
  end
end
