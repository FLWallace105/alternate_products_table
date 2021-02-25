#shopify_throttle.rb
module ShopifyThrottle
  def shopify_api_throttle
    #puts "Sleeping 3 secs anyway"
    #sleep 3

    return if ShopifyAPI.credit_left > 5

    puts "CREDITS LEFT: #{ShopifyAPI.credit_left}"
    puts "SLEEPING 20"
    sleep 20
  end
end
