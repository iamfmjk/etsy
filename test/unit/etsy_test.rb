require File.dirname(__FILE__) + '/../test_helper'

class EtsyTest < Test::Unit::TestCase

  context "The Etsy module" do
    setup { Etsy.instance_variable_set(:@environment, nil) }

    should "be able to set and retrieve the API key" do
      Etsy.api_key = 'key'
      Etsy.api_key.should == 'key'
    end

    should "be able to find a user by username" do
      user = stub()

      Etsy::User.expects(:find).with('littletjane').returns(user)
      Etsy.user('littletjane').should == user
    end

    should "use the sandbox environment by default" do
      Etsy.environment.should == :sandbox
    end

    should "be able to set the environment to a valid value" do
      Etsy.environment = :production
      Etsy.environment.should == :production
    end

    should "raise an exception when attempting to set an invalid environment" do
      lambda { Etsy.environment = :invalid }.should raise_error(ArgumentError)
    end

  end

end