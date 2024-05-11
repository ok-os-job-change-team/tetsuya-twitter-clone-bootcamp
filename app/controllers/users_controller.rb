class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'アカウントの作成に成功しました'
    else
      render :new
    end
  end

  # POST /users/:id
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = 'ユーザーは削除されました'
    else
      flash.now[:alert] = 'ユーザーの削除に失敗しました'
    end

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
