# frozen_string_literal: true

RSpec.describe ActiveRelationship, type: :model do
  describe 'associations' do
    it { should belong_to(:follower) }
  end

  describe 'class methods' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:other_user) }

    describe '.follow' do
      it 'フォローの登録ができる' do
        expect do
          ActiveRelationship.follow(user, other_user)
        end.to change(ActiveRelationship, :count).by(1)
      end
    end

    describe '.unfollow' do
      before do
        ActiveRelationship.create(follower: user, followee: other_user)
      end

      it 'フォローの解除ができる' do
        expect do
          ActiveRelationship.unfollow(user, other_user)
        end.to change(ActiveRelationship, :count).by(-1)
      end
    end
  end
end
