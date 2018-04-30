module Etsy
  class ShippingInfo
    include Etsy::Model

    attribute :id, :from => :shipping_info_id

    attributes :origin_country_id, :destination_country_id, :currency_code, :primary_cost, :secondary_cost, :listing_id, :region_id, :origin_country_name, :destination_country_name
 
    def self.find(id, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/shipping/info/#{id}", options)
    end
        
    def self.find_all_by_listing_id(listing_id, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/listings/#{listing_id}/shipping/info", options)
    end
  end
end
