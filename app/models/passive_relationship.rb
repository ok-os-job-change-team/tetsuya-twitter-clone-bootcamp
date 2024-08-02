# frozen_string_literal: true

class PassiveRelationship < Relationship
  belongs_to :followee, class_name: 'User', inverse_of: :passive_relationships

  class << self
    def unfollowed_by(user, follower)
      find_by(followee: user, follower:).destroy
    end
  end
end
