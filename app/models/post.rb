# frozen_string_literal: true

class Post < ApplicationRecord
  POSTS_PER_PAGE = 20

  belongs_to :user

  before_validation :set_default_values

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }

  class << self
    def search_by_content_or_title(query, current_page)
      offset = (current_page - 1) * POSTS_PER_PAGE

      if query.blank?
        search_all_posts(offset)
      else
        search_with_query(query, offset)
      end
    end

    private

    def search_all_posts(offset)
      posts = offset(offset).limit(POSTS_PER_PAGE)
      total_count = count
      [posts, total_count]
    end

    def search_with_query(query, offset)
      sanitized_query = sanitize_sql_like(query)
      query_with_pagination = format(load_sql('query_with_pagination.sql'), limit: POSTS_PER_PAGE, offset:)
      total_count_query = load_sql('total_count_query.sql')

      posts = find_by_sql([query_with_pagination, { query: "#{sanitized_query}%" }])
      total_count_result = find_by_sql([total_count_query, { query: "#{sanitized_query}%" }])
      total_count = total_count_result.first.total_count

      [posts, total_count]
    end

    def load_sql(filename)
      filepath = Rails.root.join('app', 'sql', filename)
      File.read(filepath)
    end
  end

  private

  def set_default_values
    self.title ||= '無題'
  end
end
