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

ActiveRecord::Schema[8.0].define(version: 2024_11_29_192722) do
  create_table "games", force: :cascade do |t|
    t.string "owner_name", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "uuid", null: false
    t.index ["owner_id"], name: "index_games_on_owner_id"
    t.index ["uuid"], name: "index_games_on_uuid", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "story_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "score"
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "round_id", null: false
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "round_id"], name: "index_votes_on_player_id_and_round_id", unique: true
    t.index ["player_id"], name: "index_votes_on_player_id"
    t.index ["round_id"], name: "index_votes_on_round_id"
  end

  add_foreign_key "games", "players", column: "owner_id"
  add_foreign_key "rounds", "games"
  add_foreign_key "votes", "players"
  add_foreign_key "votes", "rounds"
end
