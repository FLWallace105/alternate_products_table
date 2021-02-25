require 'dotenv'
require 'active_record'
require 'sinatra/activerecord/rake'

require_relative 'pull_shopify_products'

#require 'active_record/railties/databases.rake'

Dotenv.load

include ActiveRecord::Tasks

root = File.expand_path '..', __FILE__
DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(root, 'config/database.yml')))
DatabaseTasks.db_dir = File.join root, 'db'
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.root = root

ActiveRecord::Base.configurations = YAML.load(File.read(File.join(root, 'config/database.yml')))
ActiveRecord::Base.establish_connection (ENV['RACK_ENV']|| 'development')&.to_sym

load 'active_record/railties/databases.rake'



namespace :pull_shopify do
  desc 'Pull all Shopify products, variants, collects, custom collections'
  task :pull_shopify_resources do |t|
    PullShopifyProducts::ShopifyGetter.new.shopify_get_all_resources
  end

  desc 'get products for this months collection'
  task :get_product_this_month do |t|
    PullShopifyProducts::ShopifyGetter.new.get_products_this_month
  end

  


end
