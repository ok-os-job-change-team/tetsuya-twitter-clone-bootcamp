# Userクラスは、ユーザーの認証と関連する機能を提供する
# このクラスは、ユーザーが記述した投稿（Post）との1対多の関係を持つ
# ユーザー削除時には、関連する記事も削除する
# 永続的なセッションのための記憶機能を提供する
#
# == アソシエーション
# - has_many :posts, dependent: :destroy
#
# == バリデーション
# - emailの存在を確認
#
# == セキュリティ
# - has_secure_passwordを使用してパスワードのセキュアな保存と認証を実現
#
# == インスタンスメソッド
# - remember: 永続的セッションのためのトークンを生成し、記憶する
# - authenticated?: 渡されたトークンがダイジェストと一致するか確認する
# - forget: ユーザーの永続的セッションを破棄する
#
# == クラスメソッド
# - digest: 与えられた文字列のハッシュ値を返す
# - new_token: ランダムなトークンを生成して返す
class User < ApplicationRecord
  validates :email, presence: true

  has_many :posts, dependent: :destroy # ユーザー削除時に紐づく記事も削除する

  has_secure_password
end
