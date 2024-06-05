RSpec.describe SearchesController, type: :request do
  let!(:user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'GET /search' do
    context 'ログインユーザーが操作するとき' do
      include_context 'userでログインする'

      context '検索画面にアクセスするとき' do
        it 'アクセスに成功する' do
          aggregate_failures do
            get search_path
            expect(response).to have_http_status(:success)
            expect(response.body).to include '検索'
          end
        end
      end

      context '存在する結果を検索するとき' do
        it '検索結果が表示される' do
          aggregate_failures do
            get search_path, params: { query: user_post.content }
            expect(response).to have_http_status(:success)
            expect(response.body).to include user_post.content
            expect(flash[:notice]).to include '1件の検索結果が見つかりました'
          end
        end
      end

      context '存在しない結果を検索するとき' do
        it '' do
          aggregate_failures do
            get search_path, params: { query: 'hoge' }
            expect(response).to have_http_status(:success)
            expect(flash[:notice]).to include 'hogeに該当する結果はありません'
          end
        end
      end
    end

    context 'ログインしないで操作するとき' do
      context '検索画面にアクセスするとき' do
        it 'ログイン画面にリダイレクトされる' do
          aggregate_failures do
            get search_path
            expect(response).to redirect_to(login_url)
            expect(flash[:alert]).to eq('ログインしてください')
          end
        end
      end
    end
  end
end
