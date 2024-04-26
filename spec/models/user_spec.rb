RSpec.describe User, type: :model do
  describe '#validation' do
    context 'emailとpasswordがそれぞれ有効な値であるとき' do
      let(:user) { build(:user) }

      it 'userが有効であり、errorsが空である' do
        aggregate_failures do
          user.valid?
          expect(user.valid?).to be true
          expect(user.errors.full_messages).to eq([])
        end
      end
    end

    context 'emailがnilのとき' do
      let(:user) { build(:user, email: nil) }

      it 'errorsに「email列が空であるエラー」が格納される' do
        aggregate_failures do
          user.valid?
          expect(user.errors).to be_of_kind(:email, :blank)
          expect(user.errors.full_messages_for(:email)).to eq(["Email can't be blank"])
        end
      end
    end

    context 'passwordがnilのとき' do
      let(:user) { build(:user, password: nil) }

      it 'errorsに「password列が空であるエラー」が格納される' do
        aggregate_failures do
          user.valid?
          expect(user.errors).to be_of_kind(:password, :blank)
          expect(user.errors.full_messages_for(:password)).to eq(["Password can't be blank"])
        end
      end
    end
  end
end
