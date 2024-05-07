RSpec.describe UsersController, type: :request do
  describe 'GET /index' do
    let!(:user) { create(:user) }

    it 'アクセスに成功する' do
      aggregate_failures do
        get users_url
        expect(response).to have_http_status(:success)
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }

    it 'アクセスに成功する' do
      aggregate_failures do
        get user_url user.id
        expect(response).to have_http_status(:success)
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET /users/new' do
    it 'アクセスに成功する' do
      aggregate_failures do
        get new_user_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include '新規登録'
      end
    end
  end

  describe 'POST /users' do
    let!(:user) { build(:user) }

    it '新規ユーザーを作成する' do
      aggregate_failures do
        expect do
          post users_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(User.last)
      end
    end

    context 'emailがnilのとき' do
      it '新規ユーザーを作成しない' do
        aggregate_failures do
          expect do
            post users_path, params: { user: attributes_for(:user, email: nil) }
          end.not_to change(User, :count)
          expect(response.body).to include '新規登録'
        end
      end
    end
  end
end