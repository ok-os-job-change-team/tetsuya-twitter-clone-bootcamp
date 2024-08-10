# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :check_logged_in, only: %i[show create]

  # GET /posts/:post_id/comments/:id
  def show
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @ancestors = @comment.ancestors.order(id: :asc).preload(:user)
    @descendants = @comment.descendants.without_self.where(parent_id: @comment.id).preload(:user)
    @parent_id = @comment.id
    fetch_descendant_counts(@ancestors + @descendants)
  end

  # POST /posts/:post_id/comments
  def create
    # @post = Post.find(params[:post_id])
    # @comment = @post.comments.build(comment_params)
    # @comment.parent_id = params[:comment][:parent_id]
    # if @comment.save
    #   flash[:success] = 'コメントが作成されました'
    #   redirect_to post_comment_url(@post, @comment)
    # else
    #   flash[:alert] = 'コメントの作成に失敗しました'
    #   render partial: 'comments/form', locals: { post: @post, comment: @comment }, status: :unprocessable_entity
    # end

    form = Comment::BuildForm.new(
      user_id: session[:user_id],
      post: current_post,
      params: create_params
    )
    if form.save
      flash[:success] = 'コメントが作成されました'
      redirect_to post_comment_url(form.post, form.comment)
    else
      flash[:alert] = "コメントの作成に失敗しました #{form.errors.full_messages.to_sentence}"
      render partial: 'comments/form', locals: { post: form.post, comment: form.comment }, status: :unprocessable_entity
    end
  end

  private

  def current_post
    @current_post ||= Post.find(params[:post_id])
  end

  def create_params
    # params.require(:comment).permit(:comment, :parent_id).merge(user_id: current_user.id)
    params.require(:comment).permit(:comment, :parent_id)
  end

  def fetch_descendant_counts(comments)
    descendant_counts = TreePath.where(ancestor_id: comments.pluck(:id)).group(:ancestor_id).count(:descendant_id)
    @descendant_counts = {}
    descendant_counts.each do |ancestor_id, count|
      @descendant_counts[ancestor_id] = count
    end
  end
end
