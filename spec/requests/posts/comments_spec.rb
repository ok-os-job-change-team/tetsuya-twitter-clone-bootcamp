# frozen_string_literal: true

RSpec.describe Posts::CommentsController, type: :request do
  let!(:user) { create(:user) }
  let!(:user_post) { create(:post) }
  let!(:user_comment1) { create(:comment) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'Post /posts/:post_id/comments' do
    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトされる' do
        post post_comments_path(user_post.id)
        aggregate_failures do
          expect(response).to redirect_to(login_url)
          expect(flash[:alert]).to eq('ログインしてください')
        end
      end
    end

    context 'ログイン状態のとき' do
      include_context 'userでログインする'

      context 'コメント投稿に成功するとき' do
        it 'コメントが増える' do
          aggregate_failures do
            expect do
              post post_comments_path(user_post.id),
                   params: { post_id: user_post.id, comment: { comment: '新しいコメント' } }
            end.to change(Comment, :count).by(1)
            expect(flash[:success]).to eq('コメントが作成されました')
            expect(response).to redirect_to post_url(user_post)
            expect(response).to have_http_status(:found)
          end
        end
      end

      context 'コメント内容が空白のとき' do
        it 'コメントが増えない' do
          aggregate_failures do
            expect do
              post post_comments_path(user_post.id),
                   params: { post_id: user_post.id, comment: { comment: '' } }
            end.not_to change(Comment, :count)
            expect(flash[:alert]).to include('コメントの作成に失敗しました')
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
