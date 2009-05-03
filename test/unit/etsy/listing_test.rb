require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ListingTest < Test::Unit::TestCase

    describe "The Listing class" do
      
      it "should be able to find all listings by :user_id" do
        user_id = 122345
        
        response = mock_request_cycle :for => "/shops/#{user_id}/listings", :data => 'getShopListings'
        
        listing_1, listing_2 = response.result
        
        Listing.expects(:new).with(listing_1).returns('listing_1')
        Listing.expects(:new).with(listing_2).returns('listing_2')
        
        Listing.find_all_by_user_id(user_id).should == ['listing_1', 'listing_2']
      end
      
    end
    
    describe "An instance of the Listing class" do

      when_populating Listing, :from => 'getShopListings' do

        value_for :id,         :is => 24165902
        value_for :state,      :is => 'active'
        value_for :title,      :is => 'hanging with the bad boys matchbox'
        value_for :url,        :is => 'http://www.etsy.com/view_listing.php?listing_id=24165902'
        value_for :view_count, :is => 18
        value_for :created,    :is => 1240673494.49
        value_for :price,      :is => 3
        value_for :quantity,   :is => 1
        value_for :currency,   :is => 'USD'
        value_for :ending,     :is => 1251214294.49
        
      end
      
      it "should know that the listing is active" do
        listing = Listing.new
        listing.expects(:state).with().returns('active')
        
        listing.active?.should be(true)
      end
      
      it "should know that the listing is not active" do
        listing = Listing.new
        listing.expects(:state).with().returns('expired')
        
        listing.active?.should be(false)
      end
      
      it "should know the create date" do
        listing = Listing.new
        listing.expects(:created).with().returns(1240673494.49)
        
        listing.created_at.should == Time.at(1240673494.49)
      end
      
      it "should know the ending date" do
        listing = Listing.new
        listing.expects(:ending).with().returns(1240673494.49)
        
        listing.ending_at.should == Time.at(1240673494.49)
      end
      
    end
  end
end