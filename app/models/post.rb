class Post < ApplicationRecord
  belongs_to :user

  before_validation :set_default_values

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }

  private

  def set_default_values
    self.title ||= '無題'
  end
end
