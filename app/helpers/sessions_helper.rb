# SessionsHelperモジュールは、セッションの管理に関連するヘルパーメソッドを提供する
# これらのメソッドは、ユーザーのログイン状態の管理やクッキーを使った永続的なログインに使用される
module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    user_id = session[:user_id]
    return unless user_id

    user = User.find_by(id: user_id)
    return unless user && session[:user_id]

    log_in user
    user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
  end
end
