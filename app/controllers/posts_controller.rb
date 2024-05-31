class PostsController < ApplicationController
  before_action :check_logged_in, only: %i[index show]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/:id
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end
end
