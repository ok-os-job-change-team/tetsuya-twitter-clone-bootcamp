RSpec.describe UsersController, type: :request do
  let!(:user) { create(:user) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'GET /users' do
    include_context 'userでログインする'

    it 'アクセスに成功する' do
      aggregate_failures do
        get users_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET /users/:id' do
    include_context 'userでログインする'

    it 'アクセスに成功する' do
      aggregate_failures do
        get user_path user.id
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
    let!(:other_user) { build(:other_user) }

    it '新規ユーザーを作成する' do
      aggregate_failures do
        expect do
          post users_path, params: { user: attributes_for(:other_user) }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(User.last)
      end
    end

    context 'emailがnilのとき' do
      it '新規ユーザーを作成しない' do
        aggregate_failures do
          expect do
            post users_path, params: { user: attributes_for(:other_user, email: nil) }
          end.not_to change(User, :count)
          expect(response.body).to include '新規登録'
        end
      end
    end
  end

  describe 'GET /users/:id/edit' do
    include_context 'userでログインする'

    context '存在するuserにアクセスするとき' do
      it 'アクセスに成功する' do
        aggregate_failures do
          get edit_user_path(user.id)
          expect(response).to have_http_status(:success)
          expect(response.body).to include 'ユーザー情報編集'
        end
      end
    end

    context '存在しないuserにアクセスするとき' do
      it 'ユーザー一覧に移動する' do
        get edit_user_path('hoge')
        expect(response).to redirect_to(users_url)
      end
    end
  end

  describe 'PUT /users/:id' do
    include_context 'userでログインする'

    context '有効なパラメータのとき' do
      it 'ユーザーを更新する' do
        aggregate_failures do
          put user_path(user.id), params: { user: { email: 'new_email@example.com' } }
          user.reload
          expect(user.email).to eq('new_email@example.com')
          expect(response).to redirect_to(user)
        end
      end
    end

    context '無効なパラメータのとき' do
      it 'ユーザーを更新しない' do
        aggregate_failures do
          put user_path(user.id), params: { user: { email: nil } }
          user.reload
          expect(user.email).not_to be_nil
          expect(response.body).to include 'アカウント情報の更新に失敗しました'
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    include_context 'userでログインする'

    context 'ユーザーが存在するとき' do
      it 'ユーザーを削除する' do
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
      end
    end

    context 'ユーザーが存在しないとき' do
      it 'レコードが削除されない' do
        expect do
          delete user_path(0)
        end.to change(User, :count).by(0)
      end
    end
  end
end
