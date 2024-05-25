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
  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "記事", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "投稿者ID"
    t.string "title", default: "無題", null: false, comment: "タイトル"
    t.string "content", null: false, comment: "記事本文"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", comment: "ユーザー", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
