# frozen_string_literal: true

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  describe 'validation' do
    context '属性が全て有効な値であるとき' do
      let!(:post) { build(:post, user:) }

      it 'postが有効であり、errorsが空である' do
        aggregate_failures do
          expect(post.valid?).to be true
          expect(post.errors.full_messages).to eq([])
        end
      end
    end

    context 'titleがnilであるとき' do
      let!(:post) { create(:post, title: nil, user:) }

      it 'titleがデフォルト値「無題」となる' do
        aggregate_failures do
          expect(post.valid?).to be true
          expect(post.reload.title).to eq('無題')
        end
      end
    end

    context 'titleが31字であるとき' do
      let!(:post) { build(:post, title: Faker::Lorem.characters(number: 31), user:) }

      it 'errorsに「titleの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:title]).to include(a_hash_including(error: :too_long))
          expect(post.errors.full_messages_for(:title)).to eq(['タイトルは30文字以内で入力してください'])
        end
      end
    end

    context 'contentがnilであるとき' do
      let!(:post) { build(:post, content: nil, user:) }

      it 'errorsに「contentが空であるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:content]).to include(error: :blank)
          expect(post.errors.full_messages_for(:content)).to eq(['本文を入力してください'])
        end
      end
    end

    context 'contentが141字であるとき' do
      let!(:post) { build(:post, content: Faker::Lorem.characters(number: 141), user:) }

      it 'errorsに「contentの文字数が多すぎるエラー」が格納される' do
        aggregate_failures do
          expect(post.valid?).to be false
          expect(post.errors.details[:content]).to include(a_hash_including(error: :too_long))
          expect(post.errors.full_messages_for(:content)).to eq(['本文は140文字以内で入力してください'])
        end
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'resolve_posts_with_pagination' do
    context '40件のポストについて' do
      let!(:users_posts) { create_list(:post, Post::POSTS_PER_PAGE * 2, user:) }

      context 'queryが空のとき' do
        it '1ページ目が返される' do
          posts, next_cursor, prev_cursor = Post.resolve_posts_with_pagination
          aggregate_failures do
            expect(posts.size).to eq(Post::POSTS_PER_PAGE)
            expect(prev_cursor).to eq(users_posts[-1].id)
            expect(next_cursor).to eq(users_posts[- Post::POSTS_PER_PAGE].id)
          end
        end

        it '2ページ目が返される' do
          posts, next_cursor, prev_cursor = \
            Post.resolve_posts_with_pagination(last_post_id: users_posts[- Post::POSTS_PER_PAGE].id)
          aggregate_failures do
            expect(posts.size).to eq(Post::POSTS_PER_PAGE)
            expect(prev_cursor).to eq(users_posts[-1 - Post::POSTS_PER_PAGE].id)
            expect(next_cursor).to eq(users_posts[- Post::POSTS_PER_PAGE * 2].id)
          end
        end
      end

      context 'queryが存在するとき' do
        context '該当ポストが存在するとき' do
          it '該当ポストが返される' do
            posts, _next_cursor, _prev_cursor = Post.resolve_posts_with_pagination(query: users_posts.first.content)
            aggregate_failures do
              expect(posts.size).to eq(1)
              expect(posts.first.id).to eq(users_posts.first.id)
            end
          end
        end

        context '該当ポストが存在しないとき' do
          it '返るポストが0となる' do
            posts, _next_cursor, _prev_cursor = Post.resolve_posts_with_pagination(query: 'hogehogefugafuga')
            aggregate_failures do
              expect(posts.empty?).to be_truthy
            end
          end
        end
      end
    end
  end
end
