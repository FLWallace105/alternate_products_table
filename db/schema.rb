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

ActiveRecord::Schema.define(version: 2021_02_25_211739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shopify_collects", force: :cascade do |t|
    t.bigint "collect_id"
    t.bigint "collection_id"
    t.bigint "product_id"
    t.boolean "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "position"
    t.string "sort_value"
    t.index ["collect_id"], name: "index_shopify_collects_on_collect_id"
    t.index ["collection_id"], name: "index_shopify_collects_on_collection_id"
    t.index ["product_id"], name: "index_shopify_collects_on_product_id"
  end

  create_table "shopify_custom_collections", force: :cascade do |t|
    t.bigint "collection_id"
    t.string "handle"
    t.string "title"
    t.datetime "updated_at"
    t.text "body_html"
    t.datetime "published_at"
    t.string "sort_order"
    t.string "template_suffix"
    t.string "published_scope"
    t.index ["collection_id"], name: "index_shopify_custom_collections_on_collection_id"
    t.index ["title"], name: "index_shopify_custom_collections_on_title"
  end

  create_table "shopify_products", force: :cascade do |t|
    t.bigint "product_id"
    t.string "title"
    t.string "product_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "handle"
    t.string "template_suffix"
    t.text "body_html"
    t.string "tags"
    t.string "published_scope"
    t.string "vendor"
    t.jsonb "options"
    t.datetime "published_at"
    t.index ["product_id"], name: "index_shopify_products_on_product_id"
  end

  create_table "shopify_variants", force: :cascade do |t|
    t.bigint "variant_id"
    t.string "title"
    t.decimal "price", precision: 10, scale: 2
    t.string "sku"
    t.integer "position"
    t.string "inventory_policy"
    t.decimal "compare_at_price", precision: 10, scale: 2
    t.bigint "product_id"
    t.string "fulfillment_service"
    t.string "inventory_management"
    t.string "option1"
    t.string "option2"
    t.string "option3"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "taxable"
    t.string "barcode"
    t.decimal "weight", precision: 10, scale: 2
    t.string "weight_unit"
    t.integer "inventory_quantity"
    t.bigint "image_id"
    t.integer "grams"
    t.bigint "inventory_item_id"
    t.string "tax_code"
    t.integer "old_inventory_quantity"
    t.boolean "requires_shipping"
    t.index ["sku"], name: "index_shopify_variants_on_sku"
    t.index ["variant_id"], name: "index_shopify_variants_on_variant_id"
  end

end
