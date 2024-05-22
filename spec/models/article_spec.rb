RSpec.describe Article, type: :model do
  let!(:user) { create(:user) }

  describe '#validation' do
    context '属性が全て有効な値であるとき' do
      let!(:article) { create(:article, user_id: user.id) }

      it 'articleが有効であり、errorsが空である' do
        aggregate_failures do
          article.valid?
          expect(article.valid?).to be true
          expect(article.errors.full_messages).to eq([])
        end
      end
    end

    context 'titleがnilであるとき' do
      let!(:article) { build(:article, title: nil, user_id: user.id) }

      it 'errorsに「titleが空であるエラー」が格納される' do
        aggregate_failures do
          article.valid?
          expect(article.errors.details[:title]).to include(error: :blank)
          expect(article.errors.full_messages_for(:title)).to eq(["Title can't be blank"])
        end
      end
    end

    context 'titleが31字であるとき' do
      let!(:article) { build(:article, title: '0123456789012345678901234567890', user_id: user.id) }

      it 'errorsに「titleの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          article.valid?
          expect(article.errors.details[:title]).to include(a_hash_including(error: :too_long))
          expect(article.errors.full_messages_for(:title)).to eq(['Title is too long (maximum is 30 characters)'])
        end
      end
    end

    context 'contentがnilであるとき' do
      let!(:article) { build(:article, content: nil, user_id: user.id) }

      it 'errorsに「contentが空であるエラー」が格納される' do
        aggregate_failures do
          article.valid?
          expect(article.errors.details[:content]).to include(error: :blank)
          expect(article.errors.full_messages_for(:content)).to eq(["Content can't be blank"])
        end
      end
    end

    context 'contentが141字であるとき' do
      content = '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
      let!(:article) { build(:article, content:, user_id: user.id) }

      it 'errorsに「contentの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          article.valid?
          expect(article.errors.details[:content]).to include(a_hash_including(error: :too_long))
          expect(article.errors.full_messages_for(:content)).to eq(['Content is too long (maximum is 140 characters)'])
        end
      end
    end
  end

  describe 'Association' do
    it { should belong_to(:user) }
  end
end
