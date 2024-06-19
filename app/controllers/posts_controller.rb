class PostsController < ApplicationController
  before_action :check_logged_in, only: %i[index show new create]
  before_action :authorize_post_edit, only: %i[edit update destroy]

  # GET /posts
  def index
    @query = params[:query]
    @posts = Post.all.limit(10)

    return if @query.blank?

    @posts = Post.search_by_content_or_title(@query)

    flash.now[:notice] = if @posts.empty?
                           "#{@query}に該当する結果はありません"
                         else
                           "#{@posts.length}件の検索結果が見つかりました"
                         end
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

  def post_params
    params.require(:post).permit(:title, :content).merge(user_id: current_user.id)
  end

  def authorize_post_edit
    post = Post.find_by(id: params[:id])
    check_edit_authority(user_id: post.user_id, redirect_url: post_url(post))
  end
end
