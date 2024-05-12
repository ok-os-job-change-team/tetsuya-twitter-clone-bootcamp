# 404ページと500ページ
class ApplicationController < ActionController::Base
  unless Rails.env.production? # development?
    rescue_from Exception, with: :render500
    rescue_from ActiveRecord::RecordNotFound, with: :render404
    rescue_from ActionController::RoutingError, with: :render404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render404
    render 'errors/404', status: :not_found
  end

  def render500
    render 'errors/500', status: :internal_server_error
  end
end
