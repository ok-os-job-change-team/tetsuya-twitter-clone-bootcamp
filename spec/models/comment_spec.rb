# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
    it { should belong_to(:parent).class_name('Comment').optional }

    it {
      should have_many(:children).class_name('Comment').with_foreign_key('parent_id')
                                 .dependent(:restrict_with_error).inverse_of(:parent)
    }
    it {
      should have_many(:ancestor_paths).class_name('TreePath').with_foreign_key('descendant_id')
                                       .dependent(:destroy).inverse_of(:descendant)
    }
    it {
      should have_many(:descendant_paths).class_name('TreePath').with_foreign_key('ancestor_id')
                                         .dependent(:destroy).inverse_of(:ancestor)
    }
    it { should have_many(:ancestors).through(:ancestor_paths).source(:ancestor) }
    it { should have_many(:descendants).through(:descendant_paths).source(:descendant) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:comment) }
    it { should validate_length_of(:comment).is_at_most(140) }
  end
end
