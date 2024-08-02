# frozen_string_literal: true

RSpec.describe Users::FolloweesController, type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:relationship) { create(:relationship, follower: user, followee: other_user) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'GET /users/:user_id/followees' do
    context 'ログイン状態のとき' do
      include_context 'userでログインする'

      it 'followees一覧が取得できる' do
        get user_followees_path(user)
        aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response.body).to include(other_user.email)
        end
      end
    end

    context 'ログイン状態でないとき' do
      it 'ログインページにリダイレクトされる' do
        get user_followees_path(user)
        aggregate_failures do
          expect(flash[:alert]).to eq 'ログインしてください'
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end
end
