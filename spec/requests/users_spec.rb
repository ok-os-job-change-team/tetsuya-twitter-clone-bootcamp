RSpec.describe UsersController, type: :request do
  describe 'GET #index' do
    let(:user) { build(:user) }

    it 'returns http success' do
      get users_url
      expect(response).to have_http_status(:success)
    end

    it 'includes user1@example.com' do
      get users_url
      expect(response.body).to include 'user1@example.com'
    end
  end

  describe 'GET #show' do
    let(:user) { build(:user) }

    it 'returns http success' do
      get user_url user.id
      expect(response).to have_http_status(:success)
    end

    it 'includes user1@example.com' do
      get user_url user.id
      expect(response.body).to include 'user1@example.com'
    end
  end
end