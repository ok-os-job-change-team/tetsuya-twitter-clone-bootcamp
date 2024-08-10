# frozen_string_literal: true

module Users
  class FollowersController < ApplicationController
    before_action :check_logged_in

    # GET /users/:user_id/followers
    def index
      @user = User.find(params[:user_id])
      @followers = @user.followers
      @followees_counts = ActiveRelationship.where(follower_id: @followers.pluck(:id)).group(:follower_id).count
      @followers_counts = PassiveRelationship.where(followee_id: @followers.pluck(:id)).group(:followee_id).count
      @followees_by_user = current_user.active_relationships.index_by(&:followee_id)
    end
  end
end
