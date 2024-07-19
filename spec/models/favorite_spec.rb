# frozen_string_literal: true

RSpec.describe Favorite, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:post_id) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
