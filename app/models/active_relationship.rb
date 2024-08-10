# frozen_string_literal: true

# NOTE: current_userが操作できるRelationship
class ActiveRelationship < Relationship
  belongs_to :follower, class_name: 'User', inverse_of: :active_relationships

  class << self
    def follow(user, followee)
      create(follower: user, followee:)
    end

    def unfollow(user, followee)
      find_by(follower: user, followee:).destroy
    end
  end
end
