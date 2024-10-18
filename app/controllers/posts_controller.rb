# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :check_logged_in, only: %i[index show new create]
  before_action :authorize_post_edit, only: %i[edit update destroy]

  # GET /posts
  def index
    resolve_pagination!
    @favorite_counts = resolve_favorite_counts(@posts)
    @favorites = resolve_favorites(@posts)
    @comment_counts = resolve_comment_counts(@posts)
    flash.now[:notice] = "#{@query}に該当する結果はありません" if @query.present? && @posts.empty?
  end

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @favorite_count = @post.favorites.count
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @comment = Comment.new
    @comments = @post.comments.preload(:user)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_url, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  def edit
    @post = current_user.posts.find_by(id: params[:id])
  end

  # PUT /posts/:id
  def update
    @post = current_user.posts.find_by(id: params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: '投稿内容を更新しました'
    else
      flash.now[:alert] = '投稿内容の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    @post = current_user.posts.find_by(id: params[:id])

    if @post.destroy
      redirect_to posts_url, notice: '投稿を削除しました', status: :see_other
    else
      redirect_to @post, alert: '投稿の削除に失敗しました'
    end
  end

  private

  def authorize_post_edit
    post = Post.find_by(id: params[:id])
    check_edit_authority(user_id: post.user_id, redirect_url: post_url(post))
  end

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def resolve_comment_counts(posts)
    Comment.where(post_id: posts.pluck(:id)).group(:post_id).count
  end

  def resolve_favorites(posts)
    current_user.favorites.where(post_id: posts.pluck(:id)).index_by(&:post_id)
  end

  def resolve_favorite_counts(posts)
    Favorite.where(post_id: posts.pluck(:id)).group(:post_id).count
  end

  def resolve_pagination!
    @query = params[:query]
    @last_post_id = params[:last_post_id]
    @first_post_id = params[:first_post_id]
    @posts, @next_cursor, @prev_cursor = Post.resolve_posts_with_pagination(
      query: @query,
      last_post_id: @last_post_id,
      first_post_id: @first_post_id
    )
  end
end
