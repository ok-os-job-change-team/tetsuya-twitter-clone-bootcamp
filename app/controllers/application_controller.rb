# ApplicationControllerは、アプリケーション内のすべての他のコントローラの基盤となるクラスである
# 複数のコントローラ間で共有できる共通の機能やフィルタを提供する
class ApplicationController < ActionController::Base
  # sessions_helperのメソッドを継承する
  include SessionsHelper

  # 404ページ
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render 'errors/404', status: :not_found
  end
end
