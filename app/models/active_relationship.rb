# frozen_string_literal: true

class ActiveRelationship < Relationship
  belongs_to :follower, class_name: 'User', inverse_of: :active_relationships

  class << self
    def follow(user, followee)
      create(follower: user, followee:)
    end

    def unfollow(user, followee)
      find_by(follower: user, followee:).destroy
    end

    def followee?(user, followee)
      user.active_relationships.indexed_followees_by_followee_id[followee.id].present?
    end
  end
end
