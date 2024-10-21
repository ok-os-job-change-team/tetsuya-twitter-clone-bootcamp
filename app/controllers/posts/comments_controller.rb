# frozen_string_literal: true

module Posts
  class CommentsController < ApplicationController
    before_action :check_logged_in, only: %i[create]

    # POST /posts/:post_id/comments
    def create
      form = resolve_create_form
      if form.save
        flash[:success] = 'コメントが作成されました'
        redirect_to post_url(form.post)
      else
        flash[:alert] = "コメントの作成に失敗しました #{form.errors.full_messages.to_sentence}"
        render partial: 'posts/comments/form', locals: { post: form.post }, status: :unprocessable_entity
      end
    end

    private

    def create_params
      params.require(:comment).permit(:comment)
    end

    def resolve_create_form
      Comment::BuildForm.new(
        user_id: session[:user_id],
        post: Post.find(params[:post_id]),
        params: create_params
      )
    end
  end
end
