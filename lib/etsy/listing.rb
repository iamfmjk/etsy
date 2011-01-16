module Etsy

  # = Listing
  #
  # Represents a single Etsy listing.  Has the following attributes:
  #
  # [id] The unique identifier for this listing
  # [title] The title of this listing
  # [description] This listing's full description
  # [view_count] The number of times this listing has been viewed
  # [url] The full URL to this listing's detail page
  # [price] The price of this listing item
  # [currency] The currency that the seller is using for this listing item
  # [quantity] The number of items available for sale
  # [tags] An array of tags that the seller has used for this listing
  # [materials] Any array of materials that was used in the production of this item
  # [state] The current state of the item
  # [hue] The hue of the listing's primary image (HSV color).
  # [saturation] The saturation of the listing's primary image (HSV color).
  # [brightness] The value of the listing's primary image (HSV color).
  # [black_and_white?] True if the listing's primary image is in black & white.
  #
  # Additionally, the following queries on this item are available:
  #
  # [active?] Is this listing active?
  # [removed?] Has this listing been removed?
  # [sold_out?] Is this listing sold out?
  # [expired?] Has this listing expired?
  # [alchemy?] Is this listing an Alchemy item? (i.e. requested by an Etsy user)
  #
  class Listing

    include Etsy::Model

    STATES = %w(active removed sold_out expired alchemy)
    VALID_STATES = [:active, :expired, :inactive, :sold, :featured]

    attribute :id, :from => :listing_id
    attribute :view_count, :from => :views
    attribute :created, :from => :creation_tsz
    attribute :modified, :from => :last_modified_tsz
    attribute :currency, :from => :currency_code
    attribute :ending, :from => :ending_tsz

    attributes :title, :description, :state, :url, :price, :quantity,
               :tags, :materials, :hue, :saturation, :brightness, :is_black_and_white

    association :image, :from => 'Images'

    # Retrieve one or more listings by ID:
    #
    #   Etsy::Listing.find(123)
    #
    # You can find multiple listings by passing an array of identifiers:
    #
    #   Etsy::Listing.find([123, 456])
    #
    def self.find(*identifiers_and_options)
      find_one_or_more('listings', identifiers_and_options)
    end

    # Retrieve listings for a given shop.
    # By default, pulls back the first 25 active listings.
    # Defaults can be overridden using :limit, :offset, and :state
    #
    # Available states are :active, :expired, :inactive, :sold, and :featured
    # where :featured is a subset of the others.
    #
    # options = {
    #   :state => :expired,
    #   :limit => 100,
    #   :offset => 100,
    #   :token => 'toke',
    #   :secret => 'secret'
    # }
    # Etsy::Listing.find_all_by_shop_id(123, options)
    #
    def self.find_all_by_shop_id(shop_id, options = {})
      state = options.delete(:state) || :active

      raise(ArgumentError, self.invalid_state_message(state)) unless valid?(state)

      if state == :sold
        sold_listings(shop_id, options)
      else
        get_all("/shops/#{shop_id}/listings/#{state}", options)
      end
    end

    # The collection of images associated with this listing.
    #
    def images
      @images ||= Image.find_all_by_listing_id(id)
    end

    # The primary image for this listing.
    #
    def image
      images.first
    end

    def black_and_white?
      is_black_and_white
    end

    STATES.each do |method_name|
      define_method "#{method_name}?" do
        state == method_name.sub('_', '')
      end
    end

    # Time that this listing was created
    #
    def created_at
      Time.at(created)
    end

    # Time that this listing was last modified
    #
    def modified_at
      Time.at(modified)
    end

    # Time that this listing is ending (will be removed from store)
    #
    def ending_at
      Time.at(ending)
    end

    private

    def self.valid?(state)
      VALID_STATES.include?(state)
    end

    def self.invalid_state_message(state)
      "The state '#{state}' is invalid. Must be one of #{VALID_STATES.join(', ')}"
    end

    def self.sold_listings(shop_id, options = {})
      transactions = Transaction.find_all_by_shop_id(shop_id, options)
      listing_ids  = transactions.map {|t| t.listing_id }.uniq

      (listing_ids.size > 0) ? Array(find(listing_ids)) : []
    end

  end
end
