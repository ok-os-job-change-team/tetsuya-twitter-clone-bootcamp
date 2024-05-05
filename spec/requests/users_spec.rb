RSpec.describe UsersController, type: :request do
  describe 'GET #index' do
    let!(:user) { create(:user) }

    it 'returns http success' do
      aggregate_failures do
        get users_url
        expect(response).to have_http_status(:success)
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }

    it 'returns http success' do
      aggregate_failures do
        get user_url user.id
        expect(response).to have_http_status(:success)
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET #new' do
    it "renders the new template" do
      aggregate_failures do
        get new_user_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include '新規登録'
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { build(:user) }

    def create_user(user_params)
      post users_path, params: { user: user_params }
    end

    it 'creates a new user' do
      aggregate_failures do
        expect { create_user(attributes_for(:user)) }.to change(User, :count).by(1)
        expect(response).to redirect_to(User.last)
      end
    end

    it 'does not create a user with invalid params' do
      aggregate_failures do
        expect { create_user(attributes_for(:user, email: nil)) }.not_to change(User, :count)
        expect(response.body).to include '新規登録'
      end
    end
  end
end