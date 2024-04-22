RSpec.describe User, type: :model do
  context 'emailとpasswordがそれぞれ有効な値であるとき' do
    let(:user) { build(:user) }
    example 'userが有効である' do
      expect(user.valid?).to be true
    end

    example 'errorsが空である' do
      user.valid?
      expect(user.errors.full_messages).to eq([])
    end
  end

  context 'emailがnilのとき' do
    let(:user) {build(:user, email:nil)}
    example 'errorsに「email列が空であるエラー」が格納される' do
      user.valid?
      expect(user.errors).to be_of_kind(:email, :blank)
    end
  end

  context 'passwordがnilのとき' do
    let(:user) {build(:user, password:nil)}
    example 'errorsに「password列が空であるエラー」が格納される' do
      user.valid?
      expect(user.errors).to be_of_kind(:password, :blank)
    end
  end
end
