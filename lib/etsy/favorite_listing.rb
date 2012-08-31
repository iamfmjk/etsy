module Etsy
  class FavoriteListing
    include Model

    attributes :user_id, :listing_state, :listing_id, :create_date

    #Create a new favorite listing
    #
    def self.create(user listing, options = {})
      options.merge!(:require_secure => true)
      post("/users/#{user.id}/favorites/listings/#{listing.id}", options)
    end

    #Find all listings favorited by a user
    #
    def self.find_all_by_user_id(user_id, options = {})
      get_all("/users/#{user_id}/favorites/listings", options)
    end
  end
end