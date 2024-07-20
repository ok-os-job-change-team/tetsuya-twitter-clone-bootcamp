# frozen_string_literal: true

RSpec.describe RelationshipsController, type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  shared_context 'userでログインする' do
    before do
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end

  describe 'POST /users/:user_id/relationships' do
    context 'ログイン状態で' do
      include_context 'userでログインする'

      context 'フォローに成功するとき' do
        it 'relationshipが1増える' do
          aggregate_failures do
            expect do
              post user_relationships_path(other_user)
            end.to change(Relationship, :count).by(1)
            expect(user.followee?(other_user.id)).to be true
            expect(flash[:success]).to eq 'フォローしました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end

      context 'フォローに失敗するとき' do
        before do
          allow_any_instance_of(User).to receive(:follow).and_return(false)
        end

        it 'relationshipの数が変わらない' do
          aggregate_failures do
            expect do
              post user_relationships_path(other_user.id)
            end.not_to change(Relationship, :count)
            expect(user.followee?(other_user.id)).to be false
            expect(flash[:alert]).to eq 'フォローに失敗しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end
    end

    context 'ログイン状態ではないとき' do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect do
            post user_relationships_path(other_user.id)
          end.not_to change(Relationship, :count)
          expect(user.followee?(other_user.id)).to be false
          expect(flash[:alert]).to eq 'ログインしてください'
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end

  describe 'DELETE /users/:user_id/relationships/:id' do
    let!(:relationship) { create(:relationship, follower: user, followee: other_user) }

    context 'ログイン状態で' do
      include_context 'userでログインする'

      context 'フォロー解除に成功するとき' do
        it 'relationshipが1減少する' do
          aggregate_failures do
            expect do
              delete user_relationship_path(other_user, relationship)
            end.to change(Relationship, :count).by(-1)
            expect(user.followee?(other_user.id)).to be false
            expect(flash[:success]).to eq 'フォローを解除しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end

      context 'フォロー解除に失敗するとき' do
        before do
          allow_any_instance_of(User).to receive(:unfollow).and_return(false)
        end

        it 'relationshipの数が変わらない' do
          aggregate_failures do
            expect do
              delete user_relationship_path(other_user, relationship)
            end.not_to change(Relationship, :count)
            expect(user.followee?(other_user.id)).to be true
            expect(flash[:alert]).to eq 'フォロー解除に失敗しました'
            expect(response).to redirect_to(posts_url)
          end
        end
      end
    end

    context 'ログイン状態でないとき' do
      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect do
            delete user_relationship_path(other_user, relationship)
          end.not_to change(Relationship, :count)
          expect(user.followee?(other_user.id)).to be true
          expect(flash[:alert]).to eq 'ログインしてください'
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end

  describe 'GET /users/:user_id/followees' do
    let!(:relationship) { create(:relationship, follower: user, followee: other_user) }

    context 'ログイン状態のとき' do
      include_context 'userでログインする'

      it 'followees一覧が取得できる' do
        get user_followees_path(user)
        expect(response.body).to include(other_user.email)
      end
    end

    context 'ログイン状態でないとき' do
      it 'ログインページにリダイレクトされる' do
        get user_followees_path(user)
        aggregate_failures do
          expect(flash[:alert]).to eq 'ログインしてください'
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end

  describe 'GET /users/:user_id/followers' do
    let!(:relationship) { create(:relationship, follower: other_user, followee: user) }

    context 'ログイン状態のとき' do
      include_context 'userでログインする'

      it 'followers一覧が取得できる' do
        get user_followers_path(user)
        expect(response.body).to include(other_user.email)
      end
    end

    context 'ログイン状態でないとき' do
      it 'ログインページにリダイレクトされる' do
        get user_followees_path(user)
        aggregate_failures do
          expect(flash[:alert]).to eq 'ログインしてください'
          expect(response).to redirect_to(login_url)
        end
      end
    end
  end
end
