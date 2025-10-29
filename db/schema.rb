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

ActiveRecord::Schema[8.0].define(version: 2025_10_29_222123) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "card_sets", id: :string, force: :cascade do |t|
    t.string "name"
    t.date "release_date"
    t.string "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "card_set_id", null: false
    t.string "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_cards_on_lower_name"
    t.index ["name"], name: "index_cards_on_name"
  end

  create_table "categories", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "listable_type", null: false
    t.string "listable_id", null: false
    t.string "purpose", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "condition", null: false
    t.string "status", default: "active", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id", null: false
    t.index ["location_id"], name: "index_listings_on_location_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "country"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pokemon_products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "product_type", null: false
    t.string "card_set_id"
    t.string "language", default: "english"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_set_id"], name: "index_pokemon_products_on_card_set_id"
    t.index ["name"], name: "index_pokemon_products_on_name"
    t.index ["product_type"], name: "index_pokemon_products_on_product_type"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "user_name", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "card_sets", "categories"
  add_foreign_key "cards", "card_sets"
  add_foreign_key "cards", "categories"
  add_foreign_key "listings", "locations"
  add_foreign_key "listings", "users"
  add_foreign_key "pokemon_products", "card_sets", on_delete: :nullify
  add_foreign_key "sessions", "users"
end
