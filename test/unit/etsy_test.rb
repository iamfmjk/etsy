require File.expand_path('../../test_helper', __FILE__)

class EtsyTest < Test::Unit::TestCase

  context "The Etsy module" do
    setup do
      Etsy.instance_variable_set(:@protocol, nil)
      Etsy.instance_variable_set(:@environment, nil)
      Etsy.instance_variable_set(:@access_mode, nil)
      Etsy.instance_variable_set(:@callback_url, nil)
      Etsy.instance_variable_set(:@host, nil)
      Etsy.instance_variable_set(:@api_key, nil)
      Etsy.instance_variable_set(:@api_secret, nil)
      Etsy.instance_variable_set(:@permission_scopes, nil)
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

    should "be able to set the protocol to a valid value" do
      Etsy.protocol = 'http'
      Etsy.protocol.should == 'http'
    end

    should "raise an exception when attempting to set an invalid protocol" do
      lambda { Etsy.protocol = :invalid }.should raise_error(ArgumentError)
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

    should "know the host for the sandbox environment" do
      Etsy.environment = :sandbox
      Etsy.host.should == 'sandbox.openapi.etsy.com'
    end

    should "know the host for the production environment" do
      Etsy.environment = :production
      Etsy.host.should == 'openapi.etsy.com'
    end

    should "default to sandbox host" do
      Etsy.host.should == 'sandbox.openapi.etsy.com'
    end

    should "be able to set the callback url" do
      Etsy.callback_url = 'http://localhost'
      Etsy.callback_url.should == 'http://localhost'
    end

    should "default callback to out-of-band" do
      Etsy.callback_url.should == 'oob'
    end

    should "default permission scopes to an empty array" do
      Etsy.permission_scopes.should == []
    end

    should "be able to set the scopes" do
      Etsy.permission_scopes = %w(a_scope another_scope)
      Etsy.permission_scopes.should == ['a_scope', 'another_scope']
    end
  end

  context "The Etsy module when set up properly" do
    setup do
      Etsy.instance_variable_set(:@protocol, 'https')
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
