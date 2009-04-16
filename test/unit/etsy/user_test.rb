require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class UserTest < Test::Unit::TestCase

    describe "The User class" do
      
      it "should be able to find a user by username" do
        response = stub(:result => 'result')
        Request.expects(:get).with('/users/littletjane').returns(response)
        User.expects(:new).with('result').returns('user')
        
        User.find_by_username('littletjane').should == 'user'
      end
      
    end
    
    describe "An instance of the User class" do
      
      when_populating User, :from => 'getUserDetails' do
      
        value_for :username, :is => 'littletjane'
        value_for :id,       :is => 5327518
        value_for :url,      :is => 'http://www.etsy.com/shop.php?user_id=5327518'
      
      end
      
    end
    
  end
end