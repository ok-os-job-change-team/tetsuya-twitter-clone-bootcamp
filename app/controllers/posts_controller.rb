# frozen_string_literal: true

class PostsController < ApplicationController
  MAX_NUM_PAGES_DISPLAYED = Post::MAX_NUM_PAGES_DISPLAYED

  before_action :check_logged_in, only: %i[index show new create]
  before_action :authorize_post_edit, only: %i[edit update destroy]

  # GET /posts
  def index
    @current_page = (params[:page] || 1).to_i
    @query = params[:query]
    @posts, @upcoming_page_count = Post.search_by_content_or_title(@query, @current_page)
    @favorite_counts = fetch_favorite_counts(@posts)
    @favorites = fetch_favorites(@posts)
    @comment_counts = fetch_comment_counts(@posts)
    @page_range = calculate_page_range(@current_page, @upcoming_page_count)

    flash.now[:notice] = "#{@query}に該当する結果はありません" if @query.present? && @posts.empty?
  end

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @favorite_count = @post.favorites.count
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @comment = Comment.new
    @comments = @post.comments.where(parent_id: nil).preload(:user)
    @parent_id = nil
    fetch_descendant_counts(@comments)
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

  def fetch_favorite_counts(posts)
    Favorite.where(post_id: posts.pluck(:id)).group(:post_id).count
  end

  def fetch_favorites(posts)
    current_user.favorites.where(post_id: posts.pluck(:id)).index_by(&:post_id)
  end

  def fetch_comment_counts(posts)
    Comment.where(post_id: posts.pluck(:id)).group(:post_id).count
  end

  def fetch_descendant_counts(comments)
    descendant_counts = TreePath.where(ancestor_id: comments.pluck(:id)).group(:ancestor_id).count(:descendant_id)
    @descendant_counts = {}
    descendant_counts.each do |ancestor_id, count|
      @descendant_counts[ancestor_id] = count
    end
  end

  def calculate_page_range(current_page, upcoming_page_count)
    displayed_last_page_num = current_page + upcoming_page_count - 1
    displayed_start_page_num = if displayed_last_page_num <= MAX_NUM_PAGES_DISPLAYED
                                 1
                               elsif upcoming_page_count < (MAX_NUM_PAGES_DISPLAYED + 1) / 2
                                 displayed_last_page_num - MAX_NUM_PAGES_DISPLAYED + 1
                               else
                                 current_page - (MAX_NUM_PAGES_DISPLAYED - 1) / 2
                               end
    (displayed_start_page_num..displayed_last_page_num).to_a
  end

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def authorize_post_edit
    post = Post.find_by(id: params[:id])
    check_edit_authority(user_id: post.user_id, redirect_url: post_url(post))
  end
end
