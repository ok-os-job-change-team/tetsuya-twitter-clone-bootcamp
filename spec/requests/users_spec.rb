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
end