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

    finder :one, '/shops/:user_id'
    
    attribute :name, :from => :shop_name
    attribute :updated, :from => :last_updated_epoch
    attribute :created, :from => :creation_epoch
    attribute :message, :from => :sale_message

    attributes :banner_image_url, :listing_count, :title, :announcement, :user_id
   
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
    
    # A collection of listings in this user's shop. See Etsy::Listing for
    # more information
    #
    def listings
      Listing.find_all_by_user_id(user_id)
    end
    
  end
end