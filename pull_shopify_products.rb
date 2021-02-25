#pull_shopify_products.rb
require 'dotenv'
require 'httparty'
require 'shopify_api'
require 'active_record'
require 'sinatra/activerecord'
#require 'logger'

Dotenv.load
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

module PullShopifyProducts
  class ShopifyGetter
    include ProductCreator
    include ShopifyThrottle
    

    def initialize
      @shopname = ENV['SHOPIFY_SHOP_NAME']
      @api_key = ENV['SHOPIFY_API_KEY']
      @password = ENV['SHOPIFY_API_PASSWORD']

      
    end

    def shopify_get_all_resources
   
      puts "Starting all shopify resources download"
      shop_url = "https://#{@api_key}:#{@password}@#{@shopname}.myshopify.com/admin"
      puts shop_url
      
      ShopifyAPI::Base.site = shop_url
      ShopifyAPI::Base.api_version = '2020-04'
      ShopifyAPI::Base.timeout = 180

      product_count = ShopifyAPI::Product.count()

      puts "We have #{product_count} products for Ellie"
      
      cursor_num_products = 0
      num_variants = 0

      ShopifyProduct.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('shopify_products')
      ShopifyVariant.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('shopify_variants')
      Collect.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('shopify_collects')
      CustomCollection.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('shopify_custom_collections')

      products = ShopifyAPI::Product.find(:all)

      #First page
      products.each do |myp|
        puts "-----"
        puts "product_id: #{myp.id}"
        
        create_product(myp)
        puts "--------"
        #variants here
        myvariants = myp.variants

        myvariants.each do |myvar|
          puts "++++++++++++++"
          puts "variant_id: #{myvar.id}"
          puts "++++++++++++++"
          
          create_variant(myvar)
          num_variants += 1
        end

        shopify_api_throttle
        cursor_num_products += 1
      end

      while products.next_page?
        products = products.fetch_next_page

        products.each do |myp|
          puts "-----"
          create_product(myp)
          puts "product_id: #{myp.id}"
          
          puts "-----"

          #variants here
          myvariants = myp.variants
          myvariants.each do |myvar|
            puts "++++++++++++++"
            puts "variant_id: #{myvar.id}"
            puts "++++++++++++++"
            
            create_variant(myvar)
            num_variants += 1
          end

          cursor_num_products += 1
        end
        #puts "Sleeping 3 secs"
        #sleep 3
        shopify_api_throttle
      end

      puts "We have #{product_count} products for Ellie and have processed #{cursor_num_products} products"
      puts "We have #{num_variants} variants for parent products"
      

      #collects

      num_collects = 0
      collect_count = ShopifyAPI::Collect.count()
      puts "We have #{collect_count} collects"
      
      mycollects = ShopifyAPI::Collect.find(:all)

      mycollects.each do |mycollect|
        #puts mycollect.inspect
        puts "*************"
        puts "collect_id: #{mycollect.id}"
        puts "*************"
        
        create_collect(mycollect)
        num_collects += 1
        shopify_api_throttle
      end

      while mycollects.next_page?
        mycollects = mycollects.fetch_next_page
        mycollects.each do |mycollect|
          #puts mycollect.inspect
          puts "*************"
          puts "collect_id: #{mycollect.id}"
          puts "*************"
          
          create_collect(mycollect)
          num_collects += 1
        end
        #puts "Sleeping 3 secs"
        #sleep 3
        shopify_api_throttle
      end

      puts "We have #{collect_count} collects and have processed #{num_collects} collects"
      
      collection_count = ShopifyAPI::CustomCollection.count()
      puts "We have #{collection_count} collections for Ellie"
      
      num_custom_collections = 0

      mycollections = ShopifyAPI::CustomCollection.find(:all)
      mycollections.each do |myc|
        #puts myc.inspect
        puts "_________________"
        puts "custom_collection_id: #{myc.id}"
        puts "_________________"
        
        create_custom_collection(myc)
        num_custom_collections += 1
        shopify_api_throttle
      end

      while mycollections.next_page?
        mycollections = mycollections.fetch_next_page
        mycollections.each do |myc|
          #puts myc.inspect
          puts "_________________"
          puts "custom_collection_id: #{myc.id}"
          puts "_________________"
          
          create_custom_collection(myc)
          num_custom_collections += 1
        end
        #puts "Sleeping 3 secs"
        #sleep 3
        shopify_api_throttle
      end

      puts "We have #{collection_count} custom collections for Ellie and have processed #{num_custom_collections} custom collections"
      

      #Count up objects in tables
      num_products = ShopifyProduct.count
      puts "We have #{num_products} products in the db "
      
      num_variants = ShopifyVariant.count
      puts "We have #{num_variants} variants in the db"
      
      num_collects = Collect.count
      puts "We have #{num_collects} collects in the db"
      
      num_custom_collections = CustomCollection.count
      puts "We have #{num_custom_collections} custom collections in the db"
      

    end

    def test_sql
      num_products = Product.count
      puts "We have #{num_products} from the count method"

      num_products_sql = "select count(id) from reserve_shopify_products"
      my_num_products = ActiveRecord::Base.connection.exec_query(num_products_sql)
      new_num_products = ActiveRecord::Base.connection.execute(num_products_sql).values

      puts "Using values: #{new_num_products.first[0]}"
      puts my_num_products.inspect
      puts my_num_products.rows
    end

    def get_products_this_month

        shop_url = "https://#{@api_key}:#{@password}@#{@shopname}.myshopify.com/admin"
        puts shop_url
      
        ShopifyAPI::Base.site = shop_url
        ShopifyAPI::Base.api_version = '2020-04'
        ShopifyAPI::Base.timeout = 180

        File.delete('this_month_alternate_products.csv') if File.exist?('this_month_alternate_products.csv')

        column_header = ["product_title", "product_id", "variant_id", "sku", "product_collection"]
        CSV.open('this_month_alternate_products.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
            column_header = nil

        my_collection = "select collection_id from shopify_custom_collections where handle ilike 'march%2021%collection%' "

        collection_info = ActiveRecord::Base.connection.execute(my_collection).first
        #puts collection_info.inspect
        collection_id = collection_info['collection_id']

        my_products = "select product_id from shopify_collects where collection_id = #{collection_id}"
        product_info = ActiveRecord::Base.connection.execute(my_products).values
        puts product_info.inspect
        product_list = product_info.flatten
        puts product_list.inspect
        product_list.each do |myprod|
            temp_product = ShopifyProduct.find_by_product_id(myprod)
            

            if temp_product.title !~ /.\sone\stime/i
                mymeta = ShopifyAPI::Metafield.all(params: {resource: 'products', resource_id: temp_product.product_id, namespace: 'ellie_order_info', fields: 'value'})
                puts mymeta.inspect
                sleep 5
                temp_variant = ShopifyVariant.where("product_id = ?", temp_product.product_id ).first
                puts "#{temp_product.title}, #{temp_product.product_id}, #{temp_variant.variant_id}, #{temp_variant.sku}"
                if mymeta != []
                    csv_data_out = [temp_product.title, temp_product.product_id, temp_variant.variant_id, temp_variant.sku, mymeta.first.attributes['value'] ]
                else
                    csv_data_out = [temp_product.title, temp_product.product_id, temp_variant.variant_id, temp_variant.sku ]
                end
                  hdr << csv_data_out

                #puts temp_variant.inspect
            else
                #nothing
            end

        end
        #below is end for CSV
    end


    end



  end
end
