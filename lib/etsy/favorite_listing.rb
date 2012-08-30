module Etsy
  class FavoriteListing
    include Model

    attributes :user_id, :listing_state, :listing_id, :create_date

    #Find all listings favorited by a user
    #
    def self.find_all_by_user_id(user_id, options = {})
      get_all("/users/#{user_id}/favorites/listings", options)
    end
  end
end