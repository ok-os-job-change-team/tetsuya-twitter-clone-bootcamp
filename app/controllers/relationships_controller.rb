# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :check_logged_in

  # POST /users/:user_id/relationships
  def create
    user = User.find(params[:user_id])

    if current_user.follow(user)
      flash[:success] = 'フォローしました'
    else
      flash[:alert] = 'フォローに失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end

  # DELETE /users/:user_id/relationships/:id
  def destroy
    user = Relationship.find(params[:id]).followee

    if current_user.unfollow(user)
      flash[:success] = 'フォローを解除しました'
    else
      flash[:alert] = 'フォロー解除に失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end

  # GET /users/:user_id/followees
  def followees
    user = User.find(params[:user_id])
    @users = user.followees
  end

  # GET /users/:user_id/followers
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
