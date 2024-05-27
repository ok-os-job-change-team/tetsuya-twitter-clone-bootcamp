RSpec.describe PostsController, type: :request do
  let!(:user) { create(:user) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'GET /posts' do
    let!(:user_post) { create(:post, user_id: user.id) }

    context 'ログイン状態でポスト一覧にアクセスするとき' do
      include_context 'userでログインする'

      it 'アクセスに成功する' do
        aggregate_failures do
          get posts_path
          expect(response).to have_http_status(:success)
          expect(response.body).to include user_post.title
          expect(response.body).to include user_post.content
        end
      end
    end

    context 'ログインしないでポスト一覧にアクセスするとき' do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          get posts_path
          expect(response).to redirect_to(login_url)
          expect(flash[:alert]).to eq('ログインしてください')
        end
      end
    end
  end

  describe 'GET /post/:id' do
    let!(:user_post) { create(:post, user_id: user.id) }

    context 'ログイン状態でポスト詳細にアクセスするとき' do
      include_context 'userでログインする'

      it 'アクセスに成功する' do
        aggregate_failures do
          get post_path(user_post)
          expect(response).to have_http_status(:success)
          expect(response.body).to include user_post.title
          expect(response.body).to include user_post.content
        end
      end
    end

    context 'ログインしないでポスト一覧にアクセスするとき' do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          get post_path(user_post)
          expect(response).to redirect_to(login_url)
          expect(flash[:alert]).to eq('ログインしてください')
        end
      end
    end
  end
end
