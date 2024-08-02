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
    it { should have_many(:active_relationships).dependent(:destroy) }
    it { should have_many(:passive_relationships).dependent(:destroy) }
    it { should have_many(:followees).through(:active_relationships).source(:followee) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'Methods' do
    describe 'favorites' do
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
    end

    describe 'relationships' do
      let!(:user) { create(:user) }
      let!(:other_user) { create(:other_user) }

      describe '#follow' do
        it '他のユーザーをフォローする' do
          aggregate_failures do
            expect do
              user.follow(other_user)
            end.to change(user.followees, :count).by(1)
            expect(user.followee?(other_user)).to be_truthy
          end
        end
      end

      describe '#unfollow' do
        before do
          user.follow(other_user)
        end

        it '他のユーザーのフォローを解除する' do
          aggregate_failures do
            expect do
              user.unfollow(other_user)
            end.to change(user.followees, :count).by(-1)
            expect(user.followee?(other_user)).to be_falsey
          end
        end
      end

      describe '#followee?' do
        context '他のユーザーをフォローしているとき' do
          before do
            user.follow(other_user)
          end

          it 'trueが返る' do
            expect(user.followee?(other_user)).to be_truthy
          end
        end

        context '他のユーザーをフォローしていないとき' do
          it 'falseが返る' do
            expect(user.followee?(other_user)).to be_falsey
          end
        end
      end
    end
  end
end
