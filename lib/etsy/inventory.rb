module Etsy
  class Inventory
    include Etsy::Model

    attributes :products, :price_on_property, :quantity_on_property, :sku_on_property
    def self.find_by_listing_id(listing_id, options={})
      get("/listings/#{listing_id}/inventory", options)
    end

    def self.update_inventory(listing_id, options={})
      options.merge!(:require_secure => true)
      put("/listings/#{listing_id}/inventory", options)
    end

    private

    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end
  end
end