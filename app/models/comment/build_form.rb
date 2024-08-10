# frozen_string_literal: true

class Comment
  class BuildForm
    # NOTE: これをincludeすると、errorsやvalidates、valid?とかが使えるようになる。
    include ActiveModel::Validations

    # Ref: https://railsguides.jp/active_record_validations.html#%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%A0%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89
    validate :comment_valid?
    validate :tree_paths_valid?, if: -> { errors.empty? }

    # @param params [Hash]
    # @param user_id [Integer]
    # @param user_id [Post]
    def initialize(params:, user_id:, post:)
      @params = params
      @user_id = user_id
      @post = post
    end

    def save
      return false unless valid?

      ApplicationRecord.transaction do
        save_record!(comment)
        tree_paths.each { save_record!(_1) }
      end

      errors.empty?
    end

    # @return [Comment]
    def comment
      @comment ||= Comment.new(
        comment: params[:comment],
        parent_id: params[:parent_id],
        post: post,
        user_id: user_id
      )
    end

    attr_reader :params
    attr_reader :post
    attr_reader :user_id

    private

    def save_record!(record)
      return true if record.nil? || record.save

      record.errors.each { errors.add(:base, _1.full_message) }
      raise ActiveRecord::Rollback
    end

    # @return [TreePath]
    def tree_paths
      @tree_paths ||= resolve_tree_paths
    end

    def comment_valid?
      return if comment.valid?

      comment.errors.each { errors.add(:base, _1.full_message) }
    end

    def tree_paths_valid?
      tree_paths.each do |tree_path|
        next if tree_path.valid?

        tree_path.errors.each { errors.add(:base, _1.full_message) }
      end
    end

    def resolve_tree_paths
      [
        TreePath.new(ancestor: comment, descendant: comment, path_length: 0),
        *paths_to_ancestors
      ]
    end

    def paths_to_ancestors
      ancestor_paths.map do |ancestor_path|
        TreePath.new(
          ancestor_id: ancestor_path.ancestor_id,
          descendant: comment,
          path_length: ancestor_path.path_length + 1
        )
      end
    end

    def ancestor_paths
      @ancestor_paths ||= TreePath.where(descendant_id: params[:parent_id])
    end
  end
end