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

ActiveRecord::Schema[8.0].define(version: 2026_03_20_000000) do
  # NOTE:
  # Supabase由来のスキーマが `schema:load` のタイミングで既に存在すると失敗することがあるため、
  # 既に存在する場合はスキップします（ローカルDocker向け）。
  %w[
    auth
    extensions
    graphql
    graphql_public
    pgbouncer
    realtime
    storage
    vault
  ].each do |schema_name|
    begin
      create_schema schema_name
    rescue ActiveRecord::StatementInvalid
      # schema already exists, etc.
    end
  end

  # These are extensions that must be enabled in order to support this database
  # NOTE:
  # ローカルのPostgreSQL（特にDockerの公式イメージ）では、Supabase固有の拡張が入っていないことがあります。
  # `db:prepare` / `db:schema:load` が落ちるのを防ぐため、利用不可ならスキップします。
  [
    "extensions.pg_stat_statements",
    "extensions.pgcrypto",
    "extensions.uuid-ossp",
    "graphql.pg_graphql",
    "pg_catalog.plpgsql",
    "vault.supabase_vault"
  ].each do |ext|
    begin
      enable_extension ext
    rescue ActiveRecord::StatementInvalid
      # Extension not installed on this Postgres. Safe to skip for local dev.
    end
  end

  create_table "cognitive_distortion_assessments", force: :cascade do |t|
    t.integer "all_or_nothing", default: 0, null: false
    t.integer "overgeneralization", default: 0, null: false
    t.integer "mental_filter", default: 0, null: false
    t.integer "disqualifying_the_positive", default: 0, null: false
    t.integer "jumping_to_conclusions", default: 0, null: false
    t.integer "magnification_minimization", default: 0, null: false
    t.integer "emotional_reasoning", default: 0, null: false
    t.integer "should_statements", default: 0, null: false
    t.integer "labeling", default: 0, null: false
    t.integer "personalization", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_score"
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_cognitive_distortion_assessments_on_user_id"
  end

  create_table "diaries", force: :cascade do |t|
    t.string "user_id"
    t.text "content"
    t.string "mood"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "good_thing"
    t.text "improvement"
    t.text "tomorrow_goal"
  end

  create_table "memos", force: :cascade do |t|
    t.string "user_name"
    t.date "date"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phq9_assessments", force: :cascade do |t|
    t.integer "total_score"
    t.integer "q1"
    t.integer "q2"
    t.integer "q3"
    t.integer "q4"
    t.integer "q5"
    t.integer "q6"
    t.integer "q7"
    t.integer "q8"
    t.integer "q9"
    t.boolean "suicidal_ideation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["user_id"], name: "index_phq9_assessments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.string "strengths", default: [], array: true
    t.string "weaknesses", default: [], array: true
    t.string "likes", default: [], array: true
    t.string "hobbies", default: [], array: true
    t.string "short_term_goals", default: [], array: true
    t.string "long_term_goals", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_seen_guide", default: false, null: false
  end

  create_table "resilience_assessments", force: :cascade do |t|
    t.string "user_id"
    t.integer "q1"
    t.integer "q2"
    t.integer "q3"
    t.integer "q4"
    t.integer "q5"
    t.integer "q6"
    t.integer "q7"
    t.integer "q8"
    t.integer "q9"
    t.integer "novelty_seeking"
    t.integer "emotional_regulation"
    t.integer "adaptive_coping"
    t.integer "total_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_messages", force: :cascade do |t|
    t.bigint "text_support_id", null: false
    t.text "message"
    t.integer "sender_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text_support_id"], name: "index_support_messages_on_text_support_id"
  end

  create_table "text_supports", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "message"
    t.integer "status"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_records", force: :cascade do |t|
    t.string "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "supabase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supabase_id"], name: "index_users_on_supabase_id", unique: true
  end

  add_foreign_key "support_messages", "text_supports"
end
