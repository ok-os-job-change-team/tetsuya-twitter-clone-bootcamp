# SessionsControllerは、ユーザーのログインおよびログアウト機能を管理するコントローラーである
# セッションの作成、保持、破棄に関連するアクションを提供する
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      log_in_and_redirect(user)
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end

  def log_in_and_redirect(user)
    log_in user
    session_params[:remember_me] == '1' ? remember(user) : forget(user)
    redirect_to user
  end

  def handle_invalid_login
    flash.now[:alert] = 'メールアドレスまたはパスワードが無効です'
    render 'new', status: :unauthorized
  end
end
