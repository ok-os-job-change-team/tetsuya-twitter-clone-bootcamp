# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:comment) }
    it { should validate_length_of(:comment).is_at_most(140) }
  end
end
