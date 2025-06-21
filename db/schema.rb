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

ActiveRecord::Schema[7.0].define(version: 2025_06_11_000120) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "debts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "client_id", null: false
    t.integer "installments"
    t.integer "due_day"
    t.date "start_at"
    t.date "end_at"
    t.float "interest_rate"
    t.decimal "amount"
    t.decimal "quota"
    t.string "currency"
    t.string "token"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_user_id"
    t.index ["admin_user_id"], name: "index_debts_on_admin_user_id"
    t.index ["client_id"], name: "index_debts_on_client_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "admin_user_id"
    t.integer "payment_method_id"
    t.date "paid_at"
    t.string "invoice"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cost"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "provider_id"
    t.index ["admin_user_id"], name: "index_expenses_on_admin_user_id"
    t.index ["payment_method_id"], name: "index_expenses_on_payment_method_id"
    t.index ["provider_id"], name: "index_expenses_on_provider_id"
  end

  create_table "order_products", force: :cascade do |t|
    t.integer "product_id"
    t.float "price"
    t.float "units"
    t.float "total"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "client_id"
    t.float "total"
    t.integer "payment_method_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_name"
    t.datetime "order_date"
    t.decimal "total_price"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["payment_method_id"], name: "index_orders_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "debt_id", null: false
    t.integer "client_id", null: false
    t.integer "user_id", null: false
    t.decimal "amount"
    t.decimal "min_amount"
    t.datetime "due_at"
    t.string "currency"
    t.integer "installment"
    t.float "discount"
    t.integer "status"
    t.decimal "interest_amount"
    t.decimal "paid_amount"
    t.datetime "discounted_at"
    t.datetime "paid_at"
    t.decimal "default_interest_amount"
    t.decimal "paid_interest_amount"
    t.decimal "paid_default_interest_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_user_id"
    t.index ["admin_user_id"], name: "index_payments_on_admin_user_id"
    t.index ["client_id"], name: "index_payments_on_client_id"
    t.index ["debt_id"], name: "index_payments_on_debt_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "product_supplies", force: :cascade do |t|
    t.integer "product_id"
    t.integer "supply_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "units"
    t.index ["product_id"], name: "index_product_supplies_on_product_id"
    t.index ["supply_id"], name: "index_product_supplies_on_supply_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "picture"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supplies", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supply_costs", force: :cascade do |t|
    t.integer "supply_id"
    t.integer "status"
    t.float "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supply_id"], name: "index_supply_costs_on_supply_id"
  end

  create_table "supply_inventories", force: :cascade do |t|
    t.integer "supply_id"
    t.integer "operation"
    t.float "units"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cost"
    t.index ["supply_id"], name: "index_supply_inventories_on_supply_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "debts", "clients"
  add_foreign_key "debts", "users"
  add_foreign_key "expenses", "admin_users"
  add_foreign_key "expenses", "payment_methods"
  add_foreign_key "expenses", "providers"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "payment_methods"
  add_foreign_key "payments", "clients"
  add_foreign_key "payments", "debts"
  add_foreign_key "payments", "users"
  add_foreign_key "product_supplies", "products"
  add_foreign_key "product_supplies", "supplies"
  add_foreign_key "supply_costs", "supplies"
  add_foreign_key "supply_inventories", "supplies"
end
