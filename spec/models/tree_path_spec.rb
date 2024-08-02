# frozen_string_literal: true

RSpec.describe TreePath, type: :model do
  describe 'Associations' do
    it { should belong_to(:ancestor).class_name('Comment') }
    it { should belong_to(:descendant).class_name('Comment') }
  end

  describe 'Validation' do
    it { should validate_presence_of(:ancestor_id) }
    it { should validate_presence_of(:descendant_id) }
    it { should validate_presence_of(:path_length) }
    it { should validate_numericality_of(:path_length).is_less_than_or_equal_to(30) }
  end
end
