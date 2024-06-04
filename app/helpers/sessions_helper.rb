module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def check_logged_in
    return if logged_in?

    redirect_to login_url
    flash[:alert] = 'ログインしてください'
  end

  def check_edit_authority(user_id:, redirect_url:)
    return if current_user&.id == user_id.to_i

    redirect_to redirect_url
    flash[:alert] = '権限がありません'
  end

  def log_out
    session.delete(:user_id)
  end
end
