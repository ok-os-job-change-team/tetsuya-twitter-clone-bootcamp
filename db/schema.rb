ActiveRecord::Schema.define(version: 20240422130000) do

  create_table 'users', id: { type: :integer, comment: 'ユーザーID', unsigned: true, default: nil }, charset: 'utf8mb4', collation: 'utf8mb4_bin', comment: 'ユーザー', force: :cascade do |t|
    t.string 'email', default: '', null:false, comment: 'メールアドレス'
    t.string 'password', null: false, comment: 'パスワード'
  end

end