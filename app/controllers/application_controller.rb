class ApplicationController < ActionController::Base
  # sessions_helperのメソッドを継承する
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render 'errors/404', status: :not_found
  end
end
