# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :children, class_name: 'Comment', foreign_key: :parent_id, dependent: :restrict_with_error,
                      inverse_of: :parent
  has_many :ancestor_paths, class_name: 'TreePath', foreign_key: 'descendant_id', dependent: :destroy,
                            inverse_of: :descendant
  has_many :descendant_paths, class_name: 'TreePath', foreign_key: 'ancestor_id', dependent: :destroy,
                              inverse_of: :ancestor
  has_many :ancestors, through: :ancestor_paths, source: :ancestor do
    def without_self
      where.not(tree_paths: { path_length: 0 })
    end
  end

  has_many :descendants, through: :descendant_paths, source: :descendant do
    def without_self
      where.not(tree_paths: { path_length: 0 })
    end
  end

  validates :comment, presence: true, length: { maximum: 140 }
end
