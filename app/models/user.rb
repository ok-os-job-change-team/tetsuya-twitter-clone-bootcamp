# frozen_string_literal: true

class User < ApplicationRecord
  module UserFavoriteExtension
    def indexed_favorites_by_post_id
      @indexed_favorites_by_post_id ||= index_by(&:post_id)
    end
  end

  module UserRelationshipExtension
    def indexed_followees_by_followee_id
      @indexed_followees_by_followee_id ||= index_by(&:followee_id)
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

  has_many :active_relationships, lambda {
                                    extending UserRelationshipExtension
                                  }, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                     inverse_of: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy,
                                   inverse_of: :followee
  has_many :followees, through: :active_relationships, source: :followee
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(user)
    active_relationships.create(followee_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followee_id: user.id).destroy
  end

  def followee?(followee_id)
    active_relationships.indexed_followees_by_followee_id[followee_id].present?
  end
end
