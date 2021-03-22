module Etsy
  class Inventory
    include Etsy::Model

    attributes :products, :price_on_property, :quantity_on_property, :sku_on_property
    def self.find_all_by_listing_id(listing_id, options={})
      get_all("/listings/#{listing_id}/inventory", options)
    end

    private

    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end
  end
end