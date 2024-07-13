# frozen_string_literal: true

class Relationship < ApplicationRecord
  validates :follower_id, presence: true
  validates :followee_id, presence: true

  belongs_to :follower, class_name: 'User', inverse_of: :active_relationships
  belongs_to :followee, class_name: 'User', inverse_of: :passive_relationships
end
