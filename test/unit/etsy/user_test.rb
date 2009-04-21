require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class UserTest < Test::Unit::TestCase

    describe "The User class" do
      
      it "should be able to find a user by username" do
        response = mock_request_cycle :for => '/users/littletjane', :data => 'getUserDetails'
        
        User.expects(:new).with(response.result).returns('user')
        User.find_by_username('littletjane').should == 'user'
      end
      
    end
    
    describe "An instance of the User class" do
      
      when_populating User, :from => 'getUserDetails' do
      
        value_for :username,   :is => 'littletjane'
        value_for :id,         :is => 5327518
        value_for :url,        :is => 'http://www.etsy.com/shop.php?user_id=5327518'
        value_for :joined,     :is => 1191381757.93
        value_for :city,       :is => 'Washington, DC'
        value_for :gender,     :is => 'female'
        value_for :seller,     :is => true
        value_for :last_login, :is => 1239797927.39
        value_for :bio,        :is => 'hello!'
      
      end

      it "should know if it is a seller" do
        user = User.new
        user.expects(:seller).with().returns(true)
        user.seller?.should be(true)
      end
      
      it "should know the join date" do
        user = User.new
        user.stubs(:joined).with().returns(1191381757.93)
        
        user.joined_at.should == Time.at(1191381757.93)
      end
      
      it "should know the last login date" do
        user = User.new
        user.stubs(:last_login).with().returns(1239797927.39)
        
        user.last_login_at.should == Time.at(1239797927.39)
      end
      
      it "should have a shop" do
        user = User.new
        shop = stub()
        
        user.stubs(:id).with().returns(1)
        
        Shop.expects(:find_by_user_id).with(1).returns(shop)
        
        user.shop.should == shop
      end
      
    end
    
  end
end