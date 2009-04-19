module Etsy
  class Shop
    
    include Etsy::Model
    
    def self.find_by_user_id(user_id)
      response = Request.get("/shops/#{user_id}")
      new response.result
    end
    
    attribute :banner_image_url
    attribute :listing_count
    
  end
end