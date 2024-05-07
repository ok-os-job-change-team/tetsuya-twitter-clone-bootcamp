class UsersController < ApplicationController
  # GET /index
  def index
    @users = User.all
  end

  # GET /show
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

  # GET /users/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, notice: 'アカウント情報を更新しました'
    else
      flash.now[:alert] = 'アカウント情報の更新に失敗しました'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
