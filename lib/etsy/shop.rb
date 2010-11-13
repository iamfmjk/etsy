module Etsy

  # = Shop
  #
  # Represents a single Etsy shop.  Users may or may not have an associated shop.
  #
  # A shop has the following attributes:
  #
  # [name] The shop's name
  # [title] A brief heading for the shop's main page
  # [announcement] An announcement to buyers (displays on the shop's home page)
  # [message] The message sent to users who buy from this shop
  # [image_url] The full URL to the shops's banner image
  # [active_listings_count] The number of active listings present in this shop
  #
  class Shop

    include Etsy::Model

    attributes :title, :announcement, :user_id

    attribute :id, :from => :shop_id
    attribute :image_url, :from => 'image_url_760x100'
    attribute :active_listings_count, :from => 'listing_active_count'
    attribute :updated, :from => :last_updated_tsz
    attribute :created, :from => :creation_tsz
    attribute :name, :from => :shop_name
    attribute :message, :from => :sale_message

    # Retrieve one or more shops by name or ID:
    #
    #   Etsy::Shop.find('reagent')
    #
    # You can find multiple shops by passing an array of identifiers:
    #
    #   Etsy::Shop.find(['reagent', 'littletjane'])
    #
    def self.find(*identifiers_and_options)
      self.find_one_or_more('shops', identifiers_and_options)
    end

    # Retrieve a list of all shops.  By default it fetches 25 at a time, but that can
    # be configured by passing the :limit and :offset parameters:
    #
    #   Etsy::Shop.all(:limit => 100, :offset => 100)
    #
    def self.all(options = {})
      self.get_all("/shops", options)
    end

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

    # The collection of listings associated with this shop
    #
    def listings(state = nil, options = {})
      state = state ? {:state => state} : {}
      Listing.find_all_by_shop_id(id, state.merge(options).merge(oauth))
    end

    private

    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end

  end
end
