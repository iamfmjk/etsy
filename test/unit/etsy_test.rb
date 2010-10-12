require File.dirname(__FILE__) + '/../test_helper'

class EtsyTest < Test::Unit::TestCase

  context "The Etsy module" do
    setup do
      Etsy.instance_variable_set(:@environment, nil)
      Etsy.instance_variable_set(:@access_mode, nil)
      Etsy.instance_variable_set(:@api_key, nil)
      Etsy.instance_variable_set(:@api_secret, nil)
    end

    should "know the api url" do
      Etsy::API_URL.should == 'http://openapi.etsy.com'
    end

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

    should "be able to set and retrieve the API secret" do
      Etsy.api_secret = 'secret'
      Etsy.api_secret.should == 'secret'
    end

    should "be in read-mode by default" do
      Etsy.access_mode.should == :read_only
    end

    should "be able to set the access mode to a read-write" do
      Etsy.access_mode = :read_write
      Etsy.access_mode.should == :read_write
    end

    should "raise an exception when attempting to set an invalid access mode" do
      lambda { Etsy.access_mode = :invalid }.should raise_error(ArgumentError)
    end
  end

  context "The Etsy module when set up properly" do
    setup do
      Etsy.instance_variable_set(:@environment, :sandbox)
      Etsy.instance_variable_set(:@access_mode, :read_write)
      Etsy.instance_variable_set(:@api_key, 'key')
      Etsy.instance_variable_set(:@api_secret, 'secret')
    end

    should "provide a request token" do
      consumer = stub()
      request_token = stub()
      Etsy::Authorization.stubs(:consumer).with().returns(consumer)
      consumer.expects(:get_request_token).with().returns(request_token)
      Etsy.request_token == request_token
    end

    should "provide a verify url given a request token" do
      request_token = stub(:authorize_url => 'url', :secret => 'secret')
      Etsy.verify_url(request_token).should == "url&oauth_consumer_key=secret"
    end

    should "provide an access token given a request token+secret and a verifier" do
      consumer = stub()
      request_token = stub()
      access_token = stub()
      Etsy::Authorization.stubs(:consumer).with().returns(consumer)
      OAuth::RequestToken.expects(:new).with(consumer, 'token', 'secret').returns(request_token)
      request_token.expects(:get_access_token).with(:oauth_verifier => 'verifier').returns(access_token)
      Etsy.access_token('token', 'secret', 'verifier').should == access_token
    end

    should "provide a secure connection using access token and secret" do
      consumer = stub()
      access_token = stub()
      Etsy::Authorization.stubs(:consumer).with().returns(consumer)
      OAuth::AccessToken.expects(:new).with(consumer, 'token', 'secret').returns(access_token)
      @etsy = Etsy.secure_connection('token', 'secret')
      @etsy.connection.should == access_token
    end

  end

end
