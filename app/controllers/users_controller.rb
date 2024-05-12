class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
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

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
