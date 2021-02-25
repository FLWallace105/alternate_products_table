class ShopifyVariant < ActiveRecord::Base
  self.table_name = 'shopify_variants'
  belongs_to :shopify_product, primary_key: :product_id, foreign_key: :product_id
end