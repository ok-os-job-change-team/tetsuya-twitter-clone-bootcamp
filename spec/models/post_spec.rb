RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  describe '#validation' do
    context '属性が全て有効な値であるとき' do
      let!(:post) { build(:post, user_id: user.id) }

      it 'postが有効であり、errorsが空である' do
        aggregate_failures do
          expect(post.valid?).to be true
          expect(post.errors.full_messages).to eq([])
        end
      end
    end

    context 'titleがnilであるとき' do
      let!(:post) { create(:post, title: nil, user_id: user.id) }

      it 'titleがデフォルト値「無題」となる' do
        aggregate_failures do
          expect(post.valid?).to be true
          expect(post.reload.title).to eq('無題')
        end
      end
    end

    context 'titleが31字であるとき' do
      let!(:post) { build(:post, title: Faker::Lorem.characters(number: 31), user_id: user.id) }

      it 'errorsに「titleの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:title]).to include(a_hash_including(error: :too_long))
          expect(post.errors.full_messages_for(:title)).to eq(['Title is too long (maximum is 30 characters)'])
        end
      end
    end

    context 'contentがnilであるとき' do
      let!(:post) { build(:post, content: nil, user_id: user.id) }

      it 'errorsに「contentが空であるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:content]).to include(error: :blank)
          expect(post.errors.full_messages_for(:content)).to eq(["Content can't be blank"])
        end
      end
    end

    context 'contentが141字であるとき' do
      let!(:post) { build(:post, content: Faker::Lorem.characters(number: 141), user_id: user.id) }

      it 'errorsに「contentの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:content]).to include(a_hash_including(error: :too_long))
          expect(post.errors.full_messages_for(:content)).to eq(['Content is too long (maximum is 140 characters)'])
        end
      end
    end
  end

  describe 'Association' do
    it { should belong_to(:user) }
  end
end
