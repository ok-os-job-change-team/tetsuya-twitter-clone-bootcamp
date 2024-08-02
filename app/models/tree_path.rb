# frozen_string_literal: true

class TreePath < ApplicationRecord
  MAX_TREE_LENGTH = 30

  belongs_to :ancestor, class_name: 'Comment'
  belongs_to :descendant, class_name: 'Comment'

  validates :ancestor_id,   presence: true
  validates :descendant_id, presence: true
  validates :path_length,   presence: true, numericality: { less_than_or_equal_to: MAX_TREE_LENGTH }
end
