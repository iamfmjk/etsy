module Etsy

  # = Shop
  #
  # Represents a single Etsy shop.  Users may or may not have an associated shop -
  # check the result of User#seller? to find out.
  #
  # A shop has the following attributes:
  #
  # [name] The shop's name
  # [title] A brief heading for the shop's main page
  # [announcement] An announcement to buyers (displays on the shop's home page)
  # [message] The message sent to users who buy from this shop
  # [banner_image_url] The full URL to the shops's banner image
  # [listing_count] The total number of active listings contained in this shop
  #
  class Shop

    include Etsy::Model

    def self.find(*identifiers)
      response = Request.get("/shops/#{identifiers.join(',')}")
      shops = [response.result].flatten.map {|data| new(data) }

      (identifiers.length == 1) ? shops[0] : shops
    end

    def self.all(options = {})
      response = Request.get("/shops", options)
      response.result.map {|data| new(data) }
    end

    attributes :title, :announcement, :user_id

    attribute :id, :from => :shop_id
    attribute :image_url, :from => 'image_url_760x100'
    attribute :active_listings_count, :from => 'listing_active_count'
    attribute :updated, :from => :last_updated_tsz
    attribute :created, :from => :creation_tsz
    attribute :name, :from => :shop_name
    attribute :message, :from => :sale_message

    # Time that this shop was created
    #
    def created_at
      Time.at(created)
    end

    # Time that this shop was last updated
    #
    def updated_at
      Time.at(updated)
    end

    def listings
      @listings ||= Listing.find_all_by_shop_id(id)
    end

  end
end