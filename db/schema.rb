# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 0) do
  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "いいね", force: :cascade do |t|
    t.bigint "post_id", null: false, comment: "ポストID"
    t.bigint "user_id", null: false, comment: "投稿者ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_favorites_on_post_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "投稿", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "投稿者ID"
    t.string "title", default: "無題", null: false, comment: "タイトル"
    t.string "content", null: false, comment: "投稿本文"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_posts_on_content"
    t.index ["title"], name: "index_posts_on_title"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "relationships", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "フォロー", force: :cascade do |t|
    t.bigint "follower_id", null: false, comment: "フォローしたuser_id"
    t.bigint "followee_id", null: false, comment: "フォローされたuser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id"
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "ユーザー", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "favorites", "posts"
  add_foreign_key "favorites", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "relationships", "users", column: "followee_id"
  add_foreign_key "relationships", "users", column: "follower_id"
end
