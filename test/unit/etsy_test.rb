require File.expand_path('../../test_helper', __FILE__)

class EtsyTest < Test::Unit::TestCase

  context "The Etsy module" do
    setup do
      Etsy.instance_variable_set(:@environment, nil)
      Etsy.instance_variable_set(:@access_mode, nil)
      Etsy.instance_variable_set(:@api_key, nil)
      Etsy.instance_variable_set(:@api_secret, nil)
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
      Etsy.instance_variable_set(:@verification_request, nil)
    end

    should "provide a request token" do
      request = stub(:request_token => 'token')
      Etsy::VerificationRequest.stubs(:new).returns(request)

      Etsy.request_token.should == 'token'
    end

    should "be able to generate an access token" do
      Etsy::SecureClient.stubs(:new).with({
        :request_token  => 'toke',
        :request_secret => 'secret',
        :verifier       => 'verifier'
      }).returns(stub(:client => 'token'))

      Etsy.access_token('toke', 'secret', 'verifier').should == 'token'
    end

    should "provide a verification URL" do
      request = stub(:url => 'url')
      Etsy::VerificationRequest.stubs(:new).returns(request)

      Etsy.verification_url.should == 'url'
    end

  end

end
