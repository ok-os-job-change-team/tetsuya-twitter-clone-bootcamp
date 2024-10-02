# frozen_string_literal: true

class Comment
  class BuildForm
    # NOTE: これをincludeすると、errorsやvalidates、valid?とかが使えるようになる。
    include ActiveModel::Validations

    # Ref: https://railsguides.jp/active_record_validations.html#%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%A0%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89
    validate :comment_valid?

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

      ActiveRecord::Base.transaction do
        save_record!(comment)
      rescue ActiveRecord::Rollback
        return false
      end

      errors.empty?
    end

    # @return [Comment]
    def comment
      Comment.new(
        comment: params[:comment],
        post:,
        user_id:
      )
    end

    attr_reader :params, :post, :user_id

    private

    def save_record!(record)
      return true if record.nil? || record.save

      record.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
      raise ActiveRecord::Rollback
    end

    def comment_valid?
      return if comment.valid?

      comment.errors.each { errors.add(:base, _1.full_message) }
    end
  end
end
