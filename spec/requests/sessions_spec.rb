RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /login' do
    it 'アクセスに成功する' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    context '有効なパラメータのとき' do
      it 'ログインに成功する' do
        aggregate_failures do
          post login_path, params: { session: { email: user.email, password: user.password } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(posts_url)
        end
      end
    end

    context '無効なパラメータのとき' do
      it 'ログインに失敗する' do
        aggregate_failures do
          post login_path, params: { session: { email: nil, password: nil } }
          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to include 'メールアドレスまたはパスワードが無効です'
        end
      end
    end
  end

  describe 'DELETE /logout' do
    context 'ログイン中であるとき' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      it 'ログアウトする' do
        aggregate_failures do
          delete logout_path
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(login_url)
          expect(session[user.id]).to be_nil
        end
      end
    end
  end

  describe '#check_logged_in' do
    context 'ユーザーがログインしている場合' do
      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      it 'loginページにリダイレクトされない' do
        get users_path
        expect(response).not_to redirect_to(login_url)
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'loginページにリダイレクトされる' do
        get users_path
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe '#check_edit_authority' do
    context 'ログイン中のユーザー以外のeditページを開くとき' do
      let!(:other_user) { create(:other_user) }

      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      it 'ユーザー一覧画面にリダイレクトされる' do
        get edit_user_path(other_user.id)
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
