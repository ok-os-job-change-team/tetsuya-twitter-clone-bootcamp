# frozen_string_literal: true

RSpec.describe User::UserFavoriteExtension, type: :module do
  let!(:user) { create(:user) }
  let!(:post1) { create(:post) }
  let!(:post2) { create(:post) }
  let!(:favorite1) { create(:favorite, user:, post: post1) }
  let!(:favorite2) { create(:favorite, user:, post: post2) }

  before do
    user.favorites.extending(User::UserFavoriteExtension)
  end

  describe '#indexed_favorites_by_post_id' do
    it 'お気に入りポストがpost_idでインデックスされる' do
      indexed_favorites = user.favorites.indexed_favorites_by_post_id
      aggregate_failures do
        expect(indexed_favorites.keys).to match_array([post1.id, post2.id])
        expect(indexed_favorites[post1.id]).to eq(favorite1)
        expect(indexed_favorites[post2.id]).to eq(favorite2)
      end
    end
  end
end
