# Articleクラスは記事を表す
# このクラスは、Userに属し、titleとcontentを持つ
# titleとcontentの長さに制限がある
#
# == アソシエーション
# - belongs_to :user
#
# == バリデーション
# - user_idの存在を確認
# - titleの存在と長さ（最大30文字）を確認
# - contentの存在と長さ（最大140文字）を確認
class Article < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }
end
