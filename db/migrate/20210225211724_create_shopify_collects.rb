class CreateShopifyCollects < ActiveRecord::Migration[6.1]
  def change
    create_table :shopify_collects do |t|
      t.bigint :collect_id
      t.bigint :collection_id
      t.bigint :product_id
      t.boolean :featured
      t.datetime :created_at
      t.datetime :updated_at
      t.bigint :position
      t.string :sort_value
    
    end
    add_index :shopify_collects, :collect_id
    add_index :shopify_collects, :collection_id
    add_index :shopify_collects, :product_id

  end
end
