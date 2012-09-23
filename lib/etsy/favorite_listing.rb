module Etsy
  class FavoriteListing
    include Model

    attributes :user_id, :listing_state, :listing_id, :create_date

    #Create a new favorite listing
    #
    def self.create(user, listing, options = {})
      options.merge!(:require_secure => true)
      post("/users/#{user.id}/favorites/listings/#{listing.id}", options)
    end

    #Find all listings favorited by a user
    #
    def self.find_all_user_favorite_listings(user_id, options = {})
      get_all("/users/#{user_id}/favorites/listings", options)
    end

    #Find a set of favorelistings associated with a listing_id
    #
    def self.find_all_listings_favored_by(listing_id, options = {})
      get_all("/listings/#{listing_id}/favored-by", options)  
    end
  end
end