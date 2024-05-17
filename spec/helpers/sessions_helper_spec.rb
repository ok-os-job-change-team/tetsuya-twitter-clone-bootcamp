RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create(:user) }

  describe '#log_in' do
    it 'セッションユーザーIDを設定する' do
      log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#remember' do
    it 'ユーザーIDと記憶トークンのクッキーを設定する' do
      remember(user)
      aggregate_failures do
        expect(cookies.permanent.signed[:user_id]).to eq(user.id)
        expect(cookies.permanent[:remember_token]).to eq(user.remember_token)
      end
    end
  end

  describe '#current_user' do
    context 'セッションにユーザーIDが設定されている場合' do
      it '現在のユーザーを返す' do
        log_in(user)
        expect(current_user).to eq(user)
      end
    end

    context 'セッションにユーザーIDが設定されていないが、クッキーにユーザーIDが設定されている場合' do
      before do
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end

      it '現在のユーザーを返し、同時にログインする' do
        aggregate_failures do
          expect(current_user).to eq(user)
          expect(session[:user_id]).to eq(user.id) # ユーザーをログインさせる
        end
      end
    end

    context 'セッションにもクッキーにもユーザーIDが設定されていない場合' do
      it 'nilを返す' do
        expect(current_user).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'ユーザーがログインしている場合' do
      it 'trueを返す' do
        log_in(user)
        expect(logged_in?).to be_truthy
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ユーザーがログインしていない場合にfalseを返す' do
        expect(logged_in?).to be_falsey
      end
    end
  end

  describe '#forget' do
    before do
      remember(user)
    end

    it 'ユーザーIDと記憶トークンのクッキーを削除する' do
      aggregate_failures do
        forget(user)
        expect(cookies[:user_id]).to be_nil
        expect(cookies[:remember_token]).to be_nil
      end
    end
  end

  describe '#log_out' do
    before do
      log_in(user)
      remember(user)
    end

    it 'セッションのユーザーIDを削除する' do
      aggregate_failures do
        log_out
        expect(session[:user_id]).to be_nil
        expect(current_user).to be_nil
      end
    end
  end
end
