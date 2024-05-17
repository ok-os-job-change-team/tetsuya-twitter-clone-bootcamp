RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'アクセスに成功する' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    context '有効なパラメータのとき' do
      let!(:user) { create(:user) }

      it 'ログインに成功する' do
        aggregate_failures do
          post login_path, params: { session: { email: user.email, password: user.password } }
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(user_path(user))
        end
      end
    end

    context '無効なパラメータのとき' do
      let!(:user) { create(:user) }

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
      let!(:user) { create(:user) }

      before do
        post login_path, params: { session: { email: user.email, password: user.password } }
      end

      it 'ログアウトする' do
        aggregate_failures do
          delete logout_path
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(login_path)
          expect(session[user.id]).to be_nil
        end
      end
    end
  end
end
