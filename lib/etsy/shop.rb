module Etsy
  class Shop
    
    include Etsy::Model
    
    def self.find_by_user_id(user_id)
      response = Request.get("/shops/#{user_id}")
      new response.result
    end

    attribute :name, :from => :shop_name
    attribute :banner_image_url
    attribute :listing_count
    attribute :updated, :from => :last_updated_epoch
    attribute :created, :from => :creation_epoch
    attribute :title
    attribute :message, :from => :sale_message
    attribute :announcement
    
    def created_at
      Time.at(created)
    end
    
    def updated_at
      Time.at(updated)
    end
    
  end
end