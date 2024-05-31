class PostsController < ApplicationController
  before_action :check_logged_in, only: %i[index show new create]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_url, notice: '投稿しました'
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end
end
