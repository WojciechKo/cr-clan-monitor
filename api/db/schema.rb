# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_10_013148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clans", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["tag"], name: "index_clans_on_tag", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "clan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "donated", null: false
    t.integer "received", null: false
    t.string "rank", null: false
    t.index ["clan_id"], name: "index_memberships_on_clan_id"
    t.index ["player_id", "clan_id"], name: "index_memberships_on_player_id_and_clan_id", unique: true
    t.index ["player_id"], name: "index_memberships_on_player_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "membership_id"
    t.bigint "war_id"
    t.integer "cards_collected"
    t.string "collection_day_battles", array: true
    t.string "war_day_battles", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_participations_on_membership_id"
    t.index ["war_id"], name: "index_participations_on_war_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.integer "trophies", null: false
    t.integer "level", null: false
    t.index ["tag"], name: "index_players_on_tag", unique: true
  end

  create_table "wars", force: :cascade do |t|
    t.bigint "clan_id"
    t.datetime "started_at"
    t.boolean "finished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clan_id"], name: "index_wars_on_clan_id"
    t.index ["finished"], name: "index_wars_on_finished"
    t.index ["started_at"], name: "index_wars_on_started_at"
  end

  add_foreign_key "memberships", "clans"
  add_foreign_key "memberships", "players"
  add_foreign_key "participations", "memberships"
  add_foreign_key "participations", "wars"
  add_foreign_key "wars", "clans"
end
