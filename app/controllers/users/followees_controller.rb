# frozen_string_literal: true

module Users
  class FolloweesController < ApplicationController
    before_action :check_logged_in

    # GET /users/:user_id/followees
    def index
      @user = User.find(params[:user_id])
      @followees = @user.followees
      @followees_counts = ActiveRelationship.where(follower_id: @followees.pluck(:id)).group(:follower_id).count
      @followers_counts = PassiveRelationship.where(followee_id: @followees.pluck(:id)).group(:followee_id).count
      @followees_by_user = current_user.active_relationships.index_by(&:followee_id)
    end
  end
end
