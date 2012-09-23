require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class FavoriteListingTest < Test::Unit::TestCase

    context "The FavoriteListing class" do

      should "be able to find favorite listings for a user" do
        favorite_listings = mock_request('/users/1/favorites/listings', {'key' => 'value'}, 'FavoriteListing', 'findAllFavoriteListings.json')
        FavoriteListing.find_all_user_favorite_listings(1, {'key' => 'value'}).should == favorite_listings
      end

      should "be able to find favorite listings associated to a listing" do
        favorite_listings = mock_request('/listings/1/favored-by', {'key' => 'value'}, 'FavoriteListing', 'findAllFavoriteListings.json')
        FavoriteListing.find_all_listings_favored_by(1, {'key' => 'value'}).should == favorite_listings
      end

    end

    context "An instance of the FavoriteListing class" do

      context "with response data" do
        setup do
          data = read_fixture('favorite_listing/findAllFavoriteListings.json')
          @favorite_listing = FavoriteListing.new(data.first)
        end

        should "have a value for :listing_id" do
          @favorite_listing.listing_id.should == 27230877
        end

        should "have a value for :user_id" do
          @favorite_listing.user_id.should == 1
        end

        should "have a value for :listing_state" do
          @favorite_listing.listing_state.should == "active"
        end
      end

    end

  end
end