# frozen_string_literal: true

RSpec.describe Relationship, type: :model do
  describe '#validation' do
    it { should validate_presence_of(:follower_id) }
    it { should validate_presence_of(:followee_id) }
  end
  describe '#associations' do
    it { should belong_to(:follower) }
    it { should belong_to(:followee) }
  end
end
