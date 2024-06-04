class PostsController < ApplicationController
  before_action :check_logged_in, only: %i[index show new create]
  before_action :authorize_post_edit, only: %i[edit update]

  # GET /posts
  def index
    @posts = Post.all
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

  private

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def authorize_post_edit
    post = Post.find_by(id: params[:id])
    check_edit_authority(user_id: post.user_id, redirect_url: post_url(post))
  end
end
