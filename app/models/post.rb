# frozen_string_literal: true

class Post < ApplicationRecord
  POSTS_PER_PAGE = 20

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 140 }

  before_validation :set_default_values

  class << self
    def resolve_posts_with_pagination(query: nil, last_post_id: nil, first_post_id: nil)
      if query
        resolve_posts_searched_with_query_and_cursors(query:, last_post_id:,
                                                      first_post_id:)
      else
        resolve_posts_and_cursors(last_post_id:, first_post_id:)
      end
    end

    private

    def resolve_cursors(posts:)
      next_cursor = posts.last&.id
      prev_cursor = posts.first&.id

      [next_cursor, prev_cursor]
    end

    def resolve_posts_and_cursors(last_post_id: nil, first_post_id: nil)
      posts = resolve_posts_with_no_query(last_post_id:, first_post_id:)
      posts = order(id: :desc).limit(POSTS_PER_PAGE).eager_load(:user) if posts.empty?

      next_cursor, prev_cursor = resolve_cursors(posts:)

      [posts, next_cursor, prev_cursor]
    end

    def resolve_posts_searched_with_query(sanitized_query:, last_post_id: nil, first_post_id: nil)
      if last_post_id
        Post.find_by_sql(resolve_query_with_cursor(sanitized_query:, cursor: last_post_id,
                                                   direction: :desc))
      elsif first_post_id
        posts = Post.find_by_sql(resolve_query_with_cursor(sanitized_query:, cursor: first_post_id,
                                                           direction: :asc))
        posts.reverse
      else
        Post.find_by_sql(resolve_query(sanitized_query:))
      end
    end

    def resolve_posts_searched_with_query_and_cursors(query: nil, last_post_id: nil, first_post_id: nil)
      sanitized_query = sanitize_sql_like(query)
      posts = resolve_posts_searched_with_query(sanitized_query:, last_post_id:, first_post_id:)

      posts = Post.find_by_sql(resolve_query(sanitized_query:)) if posts.empty?

      resolve_preloading_user(posts:)

      next_cursor, prev_cursor = resolve_cursors(posts:)

      [posts, next_cursor, prev_cursor]
    end

    def resolve_posts_with_no_query(last_post_id: nil, first_post_id: nil)
      if last_post_id
        where('posts.id < ?', last_post_id).order(id: :desc).limit(POSTS_PER_PAGE).eager_load(:user)
      elsif first_post_id
        posts = where('posts.id > ?', first_post_id).order(id: :asc).limit(POSTS_PER_PAGE).eager_load(:user)
        posts.reverse
      else
        order(id: :desc).limit(POSTS_PER_PAGE).eager_load(:user)
      end
    end

    def resolve_preloading_user(posts:)
      ActiveRecord::Associations::Preloader.new(records: posts, associations: :user).call
    end

    def resolve_query(sanitized_query:)
      Post.sanitize_sql_array([
                                <<~SQL,
                                  (SELECT * FROM posts WHERE content LIKE ?)
                                  UNION ALL
                                  (SELECT * FROM posts WHERE title LIKE ?)
                                  ORDER BY id DESC
                                  LIMIT #{POSTS_PER_PAGE}
                                SQL
                                "#{sanitized_query}%", "#{sanitized_query}%"
                              ])
    end

    def resolve_query_with_cursor(sanitized_query:, cursor:, direction:)
      order = direction == :asc ? 'ASC' : 'DESC'
      comparator = direction == :asc ? '>' : '<'

      resolve_query_with_order_and_comparator(sanitized_query:, cursor:, order:, comparator:)
    end

    def resolve_query_with_order_and_comparator(sanitized_query:, cursor:, order:, comparator:)
      Post.sanitize_sql_array([
                                <<~SQL,
                                  (SELECT * FROM posts WHERE content LIKE ? AND posts.id #{comparator} ?)
                                  UNION ALL
                                  (SELECT * FROM posts WHERE title LIKE ? AND posts.id #{comparator} ?)
                                  ORDER BY id #{order}
                                  LIMIT #{POSTS_PER_PAGE}
                                SQL
                                "#{sanitized_query}%", cursor, "#{sanitized_query}%", cursor
                              ])
    end
  end

  private

  def set_default_values
    self.title ||= '無題'
  end
end
