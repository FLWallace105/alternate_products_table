#product_creator.rb
#require_relative '../models/product'

module ProductCreator
  def create_product(product)
    

    ShopifyProduct.create(
      product_id: product.attributes['id'],
      title: product.attributes['title'],
      product_type: product.attributes['product_type'],
      created_at: product.attributes['created_at'],
      updated_at: product.attributes['updated_at'],
      handle: product.attributes['handle'],
      template_suffix: product.attributes['template_suffix'],
      body_html: product.attributes['body_html'],
      tags: product.attributes['tags'],
      published_scope: product.attributes['published_scope'],
      vendor: product.attributes['vendor'],
      options: product.attributes['options'][0].attributes,
      published_at: product.attributes['published_at']
    )
  end

  def create_variant(variant)
    
    ShopifyVariant.create(
      variant_id: variant.attributes['id'],
      product_id: variant.prefix_options[:product_id],
      title: variant.attributes['title'],
      price: variant.attributes['price'],
      sku: variant.attributes['sku'],
      position: variant.attributes['position'],
      inventory_policy: variant.attributes['inventory_policy'],
      compare_at_price: variant.attributes['compare_at_price'],
      fulfillment_service: variant.attributes['fulfillment_service'],
      inventory_management: variant.attributes['inventory_management'],
      option1: variant.attributes['option1'],
      option2: variant.attributes['option2'],
      option3: variant.attributes['option3'],
      created_at: variant.attributes['created_at'],
      updated_at: variant.attributes['updated_at'],
      taxable: variant.attributes['taxable'],
      barcode: variant.attributes['barcode'],
      weight_unit: variant.attributes['weight_unit'],
      weight: variant.attributes['weight'],
      inventory_quantity: variant.attributes['inventory_quantity'],
      image_id: variant.attributes['image_id'],
      grams: variant.attributes['grams'],
      inventory_item_id: variant.attributes['inventory_item_id'],
      tax_code: variant.attributes['tax_code'],
      old_inventory_quantity: variant.attributes['old_inventory_quantity'],
      requires_shipping: variant.attributes['requires_shipping']
    )

    
  end

  def create_collect(collect)
    Collect.create(
      collect_id: collect.attributes['id'],
      collection_id: collect.attributes['collection_id'],
      product_id: collect.attributes['product_id'],
      featured: collect.attributes['featured'],
      created_at: collect.attributes['created_at'],
      updated_at: collect.attributes['updated_at'],
      position: collect.attributes['position'],
      sort_value: collect.attributes['sort_value']
    )
  end

    def create_variant(variant)
        
        ShopifyVariant.create(variant_id: variant.attributes['id'], product_id: variant.prefix_options[:product_id], title: variant.attributes['title'], price: variant.attributes['price'], sku: variant.attributes['sku'], position: variant.attributes['position'], inventory_policy: variant.attributes['inventory_policy'], compare_at_price: variant.attributes['compare_at_price'], fulfillment_service: variant.attributes['fulfillment_service'], inventory_management: variant.attributes['inventory_management'], option1: variant.attributes['option1'], option2: variant.attributes['option2'], option3: variant.attributes['option3'], created_at: variant.attributes['created_at'], updated_at: variant.attributes['updated_at'], taxable: variant.attributes['taxable'], barcode: variant.attributes['barcode'], weight_unit: variant.attributes['weight_unit'], weight: variant.attributes['weight'], inventory_quantity: variant.attributes['inventory_quantity'], image_id: variant.attributes['image_id'], grams: variant.attributes['grams'], inventory_item_id: variant.attributes['inventory_item_id'], tax_code: variant.attributes['tax_code'], old_inventory_quantity: variant.attributes['old_inventory_quantity'], requires_shipping: variant.attributes['requires_shipping']  )

            

    end

    def create_collect(collect)
        Collect.create(collect_id: collect.attributes['id'], collection_id: collect.attributes['collection_id'], product_id: collect.attributes['product_id'], featured: collect.attributes['featured'], created_at: collect.attributes['created_at'], updated_at: collect.attributes['updated_at'], position: collect.attributes['position'], sort_value: collect.attributes['sort_value'] )
	    

    end

    def create_custom_collection(collection)
       CustomCollection.create(collection_id: collection.attributes['id'], handle: collection.attributes['handle'], title: collection.attributes['title'], updated_at: collection.attributes['updated_at'], body_html: collection.attributes['body_html'], published_at: collection.attributes['published_at'], sort_order: collection.attributes['sort_order'], template_suffix: collection.attributes['template_suffix'], published_scope: collection.attributes['published_scope'])
        


    end

end
