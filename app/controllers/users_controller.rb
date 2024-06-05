class UsersController < ApplicationController
  before_action :check_logged_in, only: %i[index show]
  before_action :authorize_user_edit, only: %i[edit update destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user, notice: 'アカウントの作成に成功しました'
    else
      flash.now[:alert] = 'アカウントの作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/:id
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, notice: 'アカウント情報を更新しました'
    else
      flash.now[:alert] = 'アカウント情報の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to users_url, notice: 'ユーザーは削除されました', status: :see_other
    else
      redirect_to users_url, alert: 'ユーザーの削除に失敗しました'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def authorize_user_edit
    check_edit_authority(user_id: params[:id], redirect_url: users_url)
  end
end
