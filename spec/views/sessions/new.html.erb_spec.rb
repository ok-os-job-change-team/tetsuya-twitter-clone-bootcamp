RSpec.describe 'sessions/new.html.erb', type: :view do
  before do
    flash[:alert] = 'メールアドレスまたはパスワードが無効です'
    render
  end

  it 'タイトルがログインである' do
    expect(view.content_for(:title)).to eq('ログイン')
  end

  it 'ページにログインヘッダーが表示される' do
    expect(rendered).to have_selector('h1', text: 'ログイン')
  end

  it 'フラッシュメッセージが表示される' do
    expect(rendered).to have_selector('h3', text: 'メールアドレスまたはパスワードが無効です')
  end

  it 'emailフィールドが表示される' do
    aggregate_failures do
      expect(rendered).to have_selector('label', text: 'Email')
      expect(rendered).to have_selector('input[type=email][name="session[email]"]')
    end
  end

  it 'passwordフィールドが表示される' do
    aggregate_failures do
      expect(rendered).to have_selector('label', text: 'Password')
      expect(rendered).to have_selector('input[type=password][name="session[password]"]')
    end
  end

  it 'ログインボタンが表示される' do
    expect(rendered).to have_selector('input[type=submit][value="ログイン"]')
  end

  it '新規登録リンクが表示される' do
    expect(rendered).to have_link('新規登録', href: new_user_path)
  end
end
