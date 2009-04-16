require File.dirname(__FILE__) + '/../test_helper'

class EtsyTest < Test::Unit::TestCase

  describe "The Etsy module" do
    
    it "should be able to set and retrieve the API key" do
      Etsy.api_key = 'key'
      Etsy.api_key.should == 'key'
    end
    
    it "should be able to find a user by username" do
      user = stub()
      
      Etsy::User.expects(:find_by_username).with('littletjane').returns(user)
      Etsy.user('littletjane').should == user
    end
    
  end

end