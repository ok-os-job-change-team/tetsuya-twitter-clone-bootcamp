# SessionsHelperモジュールは、セッションの管理に関連するヘルパーメソッドを提供する
# これらのメソッドは、ユーザーのログイン状態の管理やクッキーを使った永続的なログインに使用される
module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーを永続的セッションに記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    user_id = session[:user_id] || cookies.signed[:user_id]
    return unless user_id

    user = User.find_by(id: user_id)
    return unless user && (session[:user_id] || user.authenticated?(cookies[:remember_token]))

    log_in user
    user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
  end
end
