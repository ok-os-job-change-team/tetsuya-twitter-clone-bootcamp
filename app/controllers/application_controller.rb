class ApplicationController < ActionController::Base
  # sessions_helperのメソッドをMIXINする
  include SessionsHelper

  # pagy gem
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render 'errors/404', status: :not_found
  end
end
