# frozen_string_literal: true

class PostsController < ApplicationController
  POSTS_PER_PAGE = 10

  before_action :check_logged_in, only: %i[index show new create]
  before_action :authorize_post_edit, only: %i[edit update destroy]

  # GET /posts
  def index
    @current_page = (params[:page] || 1).to_i
    @query = params[:query]
    @posts, total_count = Post.search_by_content_or_title(@query, @current_page)
    @total_pages = (total_count / POSTS_PER_PAGE.to_f).ceil
    @page_range = calculate_page_range(@current_page, @total_pages)

    flash.now[:notice] = "#{@query}に該当する結果はありません" if @query.present? && @posts.empty?
  end

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
    @user = @post.user
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

  def calculate_page_range(current_page, total_pages)
    if total_pages <= 5
      (1..total_pages).to_a
    elsif current_page <= 3
      (1..5).to_a
    elsif current_page >= total_pages - 2
      ((total_pages - 4)..total_pages).to_a
    else
      ((current_page - 2)..(current_page + 2)).to_a
    end
  end

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def authorize_post_edit
    post = Post.find_by(id: params[:id])
    check_edit_authority(user_id: post.user_id, redirect_url: post_url(post))
  end
end
