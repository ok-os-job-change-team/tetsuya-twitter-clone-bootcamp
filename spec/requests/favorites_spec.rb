# frozen_string_literal: true

RSpec.describe FavoritesController, type: :request do
  let!(:user) { create(:user) }
  let!(:user_post) { create(:post, user:) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'POST /posts/:post_id/favorites' do
    context 'ログイン中' do
      include_context 'userでログインする'

      context 'お気に入り登録に成功するとき' do
        it 'ポストのお気に入り数が1増加する' do
          aggregate_failures do
            expect do
              post post_favorites_path(user_post)
            end.to change(Favorite, :count).by(1)
            expect(flash[:success]).to eq 'お気に入りに登録しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end

      context 'お気に入り登録に失敗するとき' do
        it 'ポストのお気に入り数が変化しない' do
          allow_any_instance_of(Favorite).to receive(:save).and_return(false)
          aggregate_failures do
            expect do
              post post_favorites_path(user_post)
            end.not_to change(Favorite, :count)
            expect(flash[:alert]).to eq 'お気に入り登録に失敗しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end
    end

    context 'ログイン状態でないとき' do
      it 'ポストのお気に入り数が変化せず、ログインページにリダイレクトされる' do
        aggregate_failures do
          expect do
            post post_favorites_path(user_post)
          end.not_to change(Favorite, :count)
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end

  describe 'DELETE /posts/:post_id/favorites/:id' do
    let!(:favorite) { create(:favorite, user:, post: user_post) }

    context 'ログイン中' do
      include_context 'userでログインする'

      context 'お気に入り登録を解除するとき' do
        it 'ポストのお気に入り数が1減少する' do
          aggregate_failures do
            expect do
              delete post_favorite_path(user_post, favorite)
            end.to change(Favorite, :count).by(-1)
            expect(flash[:success]).to eq 'お気に入りを解除しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end

      context 'お気に入り登録の解除に失敗するとき' do
        it 'ポストのお気に入り数が変化しない' do
          allow_any_instance_of(Favorite).to receive(:destroy).and_return(false)
          aggregate_failures do
            expect do
              delete post_favorite_path(user_post, favorite)
            end.not_to change(Favorite, :count)
            expect(flash[:alert]).to eq 'お気に入り解除に失敗しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end
    end

    context 'ログイン状態でないとき' do
      it 'ポストのお気に入り数が変化せず、ログインページにリダイレクトされる' do
        aggregate_failures do
          expect do
            delete post_favorite_path(user_post, favorite)
          end.not_to change(Favorite, :count)
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end
end
