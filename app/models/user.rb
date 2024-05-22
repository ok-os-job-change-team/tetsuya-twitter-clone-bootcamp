# Userクラスは、ユーザーの認証と関連する機能を提供する
# このクラスは、ユーザーが記述した記事（Article）との1対多の関係を持つ
# ユーザー削除時には、関連する記事も削除する
# 永続的なセッションのための記憶機能を提供する
#
# == アソシエーション
# - has_many :articles, dependent: :destroy
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
  attr_accessor :remember_token

  validates :email, presence: true

  has_many :articles, dependent: :destroy # ユーザー削除時に紐づく記事も削除する

  has_secure_password

  # 与えられた文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続的セッションで使用するユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーログインを破棄する
  def forget
    update(remember_digest: nil)
  end
end
