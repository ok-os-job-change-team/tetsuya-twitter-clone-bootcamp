class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      log_in user
      redirect_to posts_url
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def handle_invalid_login
    flash.now[:alert] = 'メールアドレスまたはパスワードが無効です'
    render 'new', status: :unauthorized
  end
end
