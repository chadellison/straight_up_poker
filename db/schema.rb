# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160325065245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ai_players", force: :cascade do |t|
    t.string   "name"
    t.integer  "skill"
    t.string   "bet_style"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "game_id"
    t.integer  "cash",        default: 1000
    t.integer  "current_bet", default: 0
    t.integer  "total_bet",   default: 0
    t.string   "cards",       default: [],                 array: true
    t.boolean  "action",      default: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "winner"
    t.integer  "bets"
    t.string   "hands"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "player_count"
    t.integer  "little_blind", default: 50
    t.integer  "big_blind",    default: 100
    t.boolean  "pocket_cards", default: false
    t.boolean  "flop",         default: false
    t.boolean  "turn",         default: false
    t.boolean  "river",        default: false
    t.integer  "pot",          default: 0
    t.string   "cards",        default: [],                 array: true
    t.string   "flop_cards",   default: [],                 array: true
    t.string   "turn_card"
    t.string   "river_card"
    t.string   "all_players",  default: [],                 array: true
  end

  create_table "user_games", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.integer  "cash",            default: 1000
    t.integer  "current_bet",     default: 0
    t.integer  "total_bet",       default: 0
    t.string   "cards",           default: [],                 array: true
    t.integer  "integer",         default: 0
    t.boolean  "action",          default: true
    t.boolean  "folded",          default: false
    t.integer  "round",           default: 0
  end

end
