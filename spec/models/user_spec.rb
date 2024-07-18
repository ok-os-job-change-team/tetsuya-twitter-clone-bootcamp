# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Validation' do
    context '属性が全て有効な値であるとき' do
      let!(:user) { build(:user) }

      it 'userが有効であり、errorsが空である' do
        aggregate_failures do
          user.valid?
          expect(user.valid?).to be true
          expect(user.errors.full_messages).to eq([])
        end
      end
    end

    context 'emailがnilのとき' do
      let!(:user) { build(:user, email: nil) }

      it 'errorsに「email列が空であるエラー」が格納される' do
        aggregate_failures do
          user.valid?
          expect(user.errors.details[:email]).to include(error: :blank)
          expect(user.errors.full_messages_for(:email)).to eq(['メールアドレスを入力してください'])
        end
      end
    end

    context 'passwordがnilのとき' do
      let!(:user) { build(:user, password: nil) }

      it 'errorsに「password列が空であるエラー」が格納される' do
        aggregate_failures do
          user.valid?
          expect(user.errors.details[:password]).to include(error: :blank)
          expect(user.errors.full_messages_for(:password)).to eq(['パスワードを入力してください'])
        end
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
  end

  describe 'Methods' do
    let!(:user) { create(:user) }
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:favorite1) { create(:favorite, user:, post: post1) }

    describe '#favorited?' do
      context 'ユーザーがポストをお気に入り登録しているとき' do
        it 'trueを返す' do
          expect(user.favorited?(post1.id)).to be_truthy
        end
      end

      context 'ユーザーがポストをお気に入り登録していないとき' do
        it 'falseを返す' do
          expect(user.favorited?(post2.id)).to be_falsey
        end
      end
    end

    describe 'UserFavoriteExtension#indexed_favorites_by_post_id' do
      it 'インデックスが作成される' do
        indexed_favorites = user.favorites.indexed_favorites_by_post_id
        expect(indexed_favorites[post1.id]).to eq(favorite1)
      end
    end
  end
end
