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

ActiveRecord::Schema.define(version: 20170605174555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accesses_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "access_id"
    t.index ["access_id", "user_id"], name: "index_accesses_users_on_access_id_and_user_id", unique: true
    t.index ["access_id"], name: "index_users_accesses_on_access_id"
    t.index ["user_id"], name: "index_users_accesses_on_user_id"
  end

  create_table "ads", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "address"
    t.integer "user_id"
    t.integer "c_type_id"
    t.integer "sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ads_agrements", id: :bigint, default: -> { "nextval('ads_agreements_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "ad_id"
    t.integer "agrement_id"
    t.index ["ad_id", "agrement_id"], name: "index_ads_agrements_on_ad_id_and_agrement_id", unique: true
  end

  create_table "ads_expertises", force: :cascade do |t|
    t.integer "ad_id"
    t.integer "expertise_id"
    t.index ["ad_id", "expertise_id"], name: "index_ads_expertises_on_ad_id_and_expertise_id", unique: true
  end

  create_table "agrements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agrements_companies", id: false, force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "agrement_id"
    t.index ["agrement_id"], name: "index_companies_agrements_on_agrement_id"
    t.index ["company_id", "agrement_id"], name: "index_companies_agrements_on_company_id_and_agrement_id", unique: true
    t.index ["company_id"], name: "index_companies_agrements_on_company_id"
  end

  create_table "c_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "other_address"
    t.string "email"
    t.string "phone"
    t.time "opening_times"
    t.string "company_id"
    t.string "description"
    t.string "links"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer "user_id"
    t.integer "sub_category_id"
    t.integer "c_type_id"
  end

  create_table "companies_expertises", id: false, force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "expertise_id"
    t.index ["company_id", "expertise_id"], name: "index_companies_expertises_on_company_id_and_expertise_id", unique: true
    t.index ["company_id"], name: "index_companies_expertises_on_company_id"
    t.index ["expertise_id"], name: "index_companies_expertises_on_expertise_id"
  end

  create_table "expertises", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "user_id"], name: "index_rates_on_company_id_and_user_id", unique: true
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.string "info"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
