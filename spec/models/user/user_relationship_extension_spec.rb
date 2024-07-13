# frozen_string_literal: true

RSpec.describe User::UserRelationshipExtension, type: :module do
  let!(:user) { create(:user) }
  let!(:followee1) { create(:user, email: 'followee1@example.com') }
  let!(:followee2) { create(:user, email: 'followee2@example.com') }
  let!(:follower1) { create(:user, email: 'follower1@example.com') }
  let!(:follower2) { create(:user, email: 'follower2@example.com') }

  let!(:active_relationship1) { ActiveRelationship.create(follower: user, followee: followee1) }
  let!(:active_relationship2) { ActiveRelationship.create(follower: user, followee: followee2) }
  let!(:passive_relationship1) { PassiveRelationship.create(follower: follower1, followee: user) }
  let!(:passive_relationship2) { PassiveRelationship.create(follower: follower2, followee: user) }

  before do
    user.active_relationships.extending(User::UserRelationshipExtension)
    user.passive_relationships.extending(User::UserRelationshipExtension)
  end

  describe '#indexed_followees_by_followee_id' do
    it 'active_relationshipsをfollowee_idでインデックスする' do
      indexed_followees = user.active_relationships.indexed_followees_by_followee_id
      aggregate_failures do
        expect(indexed_followees.keys).to match_array([followee1.id, followee2.id])
        expect(indexed_followees[followee1.id]).to eq(active_relationship1)
        expect(indexed_followees[followee2.id]).to eq(active_relationship2)
      end
    end
  end

  describe '#indexed_followers_by_follower_id' do
    it 'passive_relationshipsをfollower_idでインデックスする' do
      indexed_followers = user.passive_relationships.indexed_followers_by_follower_id
      aggregate_failures do
        expect(indexed_followers.keys).to match_array([follower1.id, follower2.id])
        expect(indexed_followers[follower1.id]).to eq(passive_relationship1)
        expect(indexed_followers[follower2.id]).to eq(passive_relationship2)
      end
    end
  end
end
