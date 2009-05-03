module Etsy
  class Shop
    
    include Etsy::Model
    
    def self.find_by_user_id(user_id)
      response = Request.get("/shops/#{user_id}")
      new response.result
    end

    attribute :name, :from => :shop_name
    attribute :updated, :from => :last_updated_epoch
    attribute :created, :from => :creation_epoch
    attribute :message, :from => :sale_message

    attributes :banner_image_url, :listing_count, :title, :announcement, :user_id
    
    def created_at
      Time.at(created)
    end
    
    def updated_at
      Time.at(updated)
    end
    
    def listings
      Listing.find_all_by_user_id(user_id)
    end
    
  end
end