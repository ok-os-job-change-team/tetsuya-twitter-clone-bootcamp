# frozen_string_literal: true

class Post < ApplicationRecord
  POSTS_PER_PAGE = 20
  MAX_NUM_PAGES_DISPLAYED = 5

  belongs_to :user

  before_validation :set_default_values

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }

  class << self
    def search_by_content_or_title(query, current_page)
      offset = (current_page - 1) * POSTS_PER_PAGE

      if query.blank?
        search_all_posts(offset, current_page)
      else
        search_with_query(query, offset, current_page)
      end
    end

    private

    def search_all_posts(offset, current_page)
      num_pages_on_standby = calculate_num_pages_on_standby(current_page)

      # 現在ページから、最大表示ページ数に達する数の投稿を取得する
      posts_on_standby = offset(offset).limit(POSTS_PER_PAGE * num_pages_on_standby)
      posts_to_display = posts_on_standby[0...POSTS_PER_PAGE]

      # 実際に得られた投稿数から、表示する残りページ数を計算する
      upcoming_page_count = (posts_on_standby.size.to_f / POSTS_PER_PAGE).ceil

      [posts_to_display, upcoming_page_count]
    end

    def search_with_query(query, offset, current_page)
      num_pages_on_standby = calculate_num_pages_on_standby(current_page)

      # 最大表示ページ数に達する数の投稿を取得するためのSQLをセットする
      sanitized_query = sanitize_sql_like(query)
      query_with_pagination = format(load_sql('query_with_pagination.sql'),
                                     limit: POSTS_PER_PAGE * num_pages_on_standby, offset:)

      posts_on_standby = find_by_sql([query_with_pagination, { query: "#{sanitized_query}%" }])
      posts_to_display = posts_on_standby[0...POSTS_PER_PAGE]

      # 実際に得られた投稿数から、表示する残りページ数を計算する
      upcoming_page_count = (posts_on_standby.size.to_f / POSTS_PER_PAGE).ceil

      [posts_to_display, upcoming_page_count]
    end

    # 現在ページから最大表示ページ数に達するために必要なページ数の計算
    def calculate_num_pages_on_standby(current_page)
      if current_page <= (MAX_NUM_PAGES_DISPLAYED + 1) / 2
        MAX_NUM_PAGES_DISPLAYED - (current_page - 1)
      else
        MAX_NUM_PAGES_DISPLAYED / 2 + 1
      end
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
