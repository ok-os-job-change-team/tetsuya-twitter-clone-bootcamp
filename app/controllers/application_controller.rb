# 404ページと500ページ
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  private

  def render_not_found
    render 'errors/404', status: :not_found
  end
end
