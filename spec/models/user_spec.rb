require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  example 'userが有効である' do
    expect(user.valid?).to be true
  end

  example 'errorsが空である' do
    expect(user.errors.full_messages).to eq([])
  end
end
