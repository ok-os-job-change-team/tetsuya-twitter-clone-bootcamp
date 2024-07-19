# frozen_string_literal: true

class User < ApplicationRecord
  module UserFavoriteExtension
    def indexed_favorites_by_post_id
      @indexed_favorites_by_post_id ||= index_by(&:post_id)
    end
  end

  validates :email, presence: true

  has_many :posts, dependent: :destroy, inverse_of: :user
  has_many :favorites, -> { extending UserFavoriteExtension }, dependent: :destroy, inverse_of: :user
  has_many :favorited_posts, through: :favorites, source: :post

  has_secure_password

  def favorited?(post_id)
    favorites.indexed_favorites_by_post_id[post_id].present?
  end
end
