class CreateShopifyCustomCollection < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_custom_collections do |t|
      t.bigint :collection_id
      t.string :handle
      t.string :title
      t.datetime :updated_at
      t.text :body_html
      t.datetime :published_at
      t.string :sort_order
      t.string :template_suffix
      t.string :published_scope
    


    end
    add_index :shopify_custom_collections, :collection_id
    add_index :shopify_custom_collections, :title

  end
end
