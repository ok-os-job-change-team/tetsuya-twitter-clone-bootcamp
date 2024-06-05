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

  describe 'GET /posts/:id/edit' do
    include_context 'userでログインする'

    context 'ログインユーザーが自身の投稿編集ページにアクセスするとき' do
      let!(:user_post) { create(:post, user_id: user.id) }

      it 'アクセスに成功する' do
        aggregate_failures do
          get edit_post_path(user_post)
          expect(response).to have_http_status(:success)
          expect(response.body).to include '投稿編集'
        end
      end
    end

    context 'ログインユーザーが他者の投稿編集ページにアクセスするとき' do
      let!(:other_user) { create(:other_user) }
      let!(:other_user_post) { create(:post, user_id: other_user.id) }

      it '投稿詳細画面にリダイレクトされる' do
        aggregate_failures do
          get edit_post_path(other_user_post)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(post_url(other_user_post))
          expect(flash[:alert]).to include '権限がありません'
        end
      end
    end
  end

  describe 'PUT /posts/:id' do
    include_context 'userでログインする'
    let!(:user_post) { create(:post, user_id: user.id) }

    context 'ログインユーザーが自身の投稿を更新するとき' do
      context '更新内容が正常なパラメータのとき' do
        it '更新に成功する' do
          aggregate_failures do
            put post_path(user_post.id), params: { post: { title: 'new title', content: 'new content' } }
            expect(user_post.reload.title).to eq('new title')
            expect(user_post.reload.content).to eq('new content')
            expect(response).to redirect_to(post_url(user_post))
            expect(flash[:notice]).to include '投稿内容を更新しました'
          end
        end
      end

      context 'contentがnilのとき' do
        it '投稿は更新されず、投稿詳細画面にリダイレクトされる' do
          aggregate_failures do
            put post_path(user_post.id), params: { post: { content: nil } }
            expect(user_post.reload.title).to eq(user_post.title)
            expect(user_post.reload.content).to eq(user_post.content)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(flash[:alert]).to include '投稿内容の更新に失敗しました'
          end
        end
      end
    end

    context 'ログインユーザーが他者の投稿を更新するとき' do
      let!(:other_user) { create(:other_user) }
      let!(:other_user_post) { create(:post, user_id: other_user.id) }

      it '投稿は更新されず、投稿一覧画面にリダイレクトされる' do
        aggregate_failures do
          put post_path(other_user_post.id), params: { post: { title: 'new title', content: 'new content' } }
          expect(other_user_post.reload.title).to eq(other_user_post.title)
          expect(other_user_post.reload.content).to eq(other_user_post.content)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(post_url(other_user_post))
          expect(flash[:alert]).to include '権限がありません'
        end
      end
    end
  end

  describe 'DELETE /posts/:id' do
    include_context 'userでログインする'

    context 'ログインユーザーが自身の投稿を削除するとき' do
      let!(:user_post) { create(:post, user_id: user.id) }

      it '投稿が削除される' do
        aggregate_failures do
          expect do
            delete post_path(user_post)
          end.to change(Post, :count).by(-1)
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to(posts_url)
          expect(flash[:notice]).to include '投稿を削除しました'
        end
      end
    end

    context 'ログインユーザーが他者の投稿を削除するとき' do
      let!(:other_user) { create(:other_user) }
      let!(:other_user_post) { create(:post, user_id: other_user.id) }

      it '投稿は削除されず、投稿一覧画面にリダイレクトされる' do
        aggregate_failures do
          expect do
            delete post_path(other_user_post)
          end.not_to change(Post, :count)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(post_url(other_user_post))
          expect(flash[:alert]).to include '権限がありません'
        end
      end
    end
  end
end
