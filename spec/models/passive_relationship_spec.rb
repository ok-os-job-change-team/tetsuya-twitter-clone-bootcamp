# frozen_string_literal: true

RSpec.describe PassiveRelationship, type: :model do
  describe 'associations' do
    it { should belong_to(:followee) }
  end

  describe 'class methods' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    describe '.unfollowed_by' do
      before do
        PassiveRelationship.create(follower: other_user, followee: user)
      end

      it 'フォローの解除ができる' do
        expect do
          PassiveRelationship.unfollowed_by(user, other_user)
        end.to change(PassiveRelationship, :count).by(-1)
      end
    end
  end
end
