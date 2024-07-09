# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :check_logged_in, only: %i[create destroy]

  # POST /posts/:post_id/favorites
  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.build(post: @post)
    if @favorite.save
      flash[:success] = 'お気に入りに登録しました'
    else
      flash[:alert] = 'お気に入り登録に失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end

  # DELETE /posts/:post_id/favorites/:id
  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(id: params[:id])
    if @favorite.destroy
      flash[:success] = 'お気に入りを解除しました'
    else
      flash[:alert] = 'お気に入り解除に失敗しました'
    end

    redirect_back(fallback_location: posts_url)
  end
end
