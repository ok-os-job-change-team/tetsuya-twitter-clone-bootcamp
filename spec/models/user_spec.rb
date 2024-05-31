RSpec.describe User, type: :model do
  describe '#validation' do
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
          expect(user.errors.full_messages_for(:email)).to eq(["Email can't be blank"])
        end
      end
    end

    context 'passwordがnilのとき' do
      let!(:user) { build(:user, password: nil) }

      it 'errorsに「password列が空であるエラー」が格納される' do
        aggregate_failures do
          user.valid?
          expect(user.errors.details[:password]).to include(error: :blank)
          expect(user.errors.full_messages_for(:password)).to eq(["Password can't be blank"])
        end
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:posts) }
  end
end
