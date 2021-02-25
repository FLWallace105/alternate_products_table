class CreateShopifyProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_products do |t|
      
      t.bigint :product_id
      t.string :title
      t.string :product_type
      t.datetime :created_at
      t.datetime :updated_at
      t.string :handle
      t.string :template_suffix
      t.text :body_html
      t.string :tags
      t.string :published_scope
      t.string :vendor
      t.jsonb :options
      t.datetime :published_at

    end
    add_index :shopify_products, :product_id

  end
end
