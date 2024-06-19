class Post < ApplicationRecord
  belongs_to :user

  before_validation :set_default_values

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }

  def self.search_by_content_or_title(query)
    sql = <<-SQL
      SELECT `posts`.* FROM `posts`#{' '}
      WHERE content LIKE :query#{' '}
      UNION#{' '}
      SELECT `posts`.* FROM `posts`#{' '}
      WHERE title LIKE :query#{' '}
      LIMIT 10
    SQL
    find_by_sql([sql, { query: "#{query}%" }])
  end

  private

  def set_default_values
    self.title ||= '無題'
  end
end
