class SearchesController < ApplicationController
  before_action :check_logged_in

  # GET /search
  def search
    @query = params[:query]
    @posts = []

    return if @query.blank?

    @posts = Post.where('title LIKE ? OR content LIKE ?', "%#{@query}%", "%#{@query}%")

    flash.now[:notice] = if @posts.empty?
                           "#{@query}に該当する結果はありません"
                         else
                           "#{@posts.length}件の検索結果が見つかりました"
                         end
  end
end
