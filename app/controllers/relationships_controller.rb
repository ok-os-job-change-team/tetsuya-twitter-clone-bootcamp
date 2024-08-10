# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :check_logged_in

  # POST /users/:user_id/relationships
  def create
    if current_user.follow(User.find(params[:user_id]))
      flash[:success] = 'フォローしました'
    else
      flash[:alert] = 'フォローに失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end

  # DELETE /users/:user_id/relationships/:id
  def destroy
    if current_user.unfollow(Relationship.find(params[:id]).followee)
      flash[:success] = 'フォローを解除しました'
    else
      flash[:alert] = 'フォロー解除に失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end
end
