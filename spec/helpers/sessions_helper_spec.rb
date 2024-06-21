# frozen_string_literal: true

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create(:user) }

  describe '#log_in' do
    it 'セッションユーザーIDを設定する' do
      log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#current_user' do
    context 'セッションにユーザーIDが設定されている場合' do
      it '現在のユーザーを返す' do
        log_in(user)
        expect(current_user).to eq(user)
      end
    end

    context 'セッションにユーザーIDが設定されていない場合' do
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
      it 'falseを返す' do
        expect(logged_in?).to be_falsey
      end
    end
  end

  describe '#log_out' do
    before do
      log_in(user)
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
