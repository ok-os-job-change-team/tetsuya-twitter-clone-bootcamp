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

  describe 'GET /posts/new' do
    context 'ログイン状態で新規投稿画面にアクセスするとき' do
      include_context 'userでログインする'

      it 'アクセスに成功する' do
        aggregate_failures do
          get new_post_path
          expect(response).to have_http_status(:success)
          expect(response.body).to include '新規投稿'
        end
      end
    end

    context 'ログインしないで新規投稿画面にアクセスするとき' do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          get new_post_path
          expect(response).to redirect_to(login_url)
          expect(flash[:alert]).to eq('ログインしてください')
        end
      end
    end
  end

  describe 'POST /posts' do
    context 'ログイン状態で新規投稿するとき' do
      include_context 'userでログインする'

      context '投稿のパラメータが有効であるとき' do
        it '投稿に成功し、投稿一覧画面にリダイレクトされる' do
          aggregate_failures do
            expect do
              post posts_path, params: { post: attributes_for(:post, user_id: user.id) }
            end.to change(Post, :count).by(1)
            expect(response).to redirect_to posts_url
          end
        end
      end

      context 'contentがnilであるとき' do
        it '投稿に失敗し、新規投稿画面がリロードされる' do
          aggregate_failures do
            expect do
              post posts_path, params: { post: attributes_for(:post, content: nil, user_id: user.id) }
            end.not_to change(Post, :count)
            expect(response.body).to include '新規投稿'
            expect(flash[:alert]).to eq('投稿に失敗しました')
          end
        end
      end
    end

    context 'ログインしないで新規投稿するとき' do
      it '投稿に失敗し、ログイン画面にリダイレクトされる' do
        aggregate_failures do
          expect do
            post posts_path, params: { post: attributes_for(:post, user_id: user.id) }
          end.not_to change(Post, :count)
          expect(response).to redirect_to(login_url)
          expect(flash[:alert]).to eq('ログインしてください')
        end
      end
    end
  end
end
