require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class SecureClientTest < Test::Unit::TestCase

    context "An instance of the SecureClient class" do

      should "be able to generate an OAuth consumer for the sandbox" do
        Etsy.stubs(:environment).returns :sandbox
        Etsy.stubs(:host).returns 'sandbox'
        Etsy.stubs(:api_key).returns('key')
        Etsy.stubs(:api_secret).returns('secret')
        Etsy.stubs(:permission_scopes).returns(['scope_one', 'scope_two'])

        OAuth::Consumer.stubs(:new).with('key', 'secret', {
          :site               => 'https://sandbox',
          :request_token_path => '/v2/oauth/request_token?scope=scope_one+scope_two',
          :access_token_path  => '/v2/oauth/access_token',
        }).returns('consumer')

        client = SecureClient.new

        client.consumer.should == 'consumer'
      end

      should "be able to generate an OAuth consumer in production" do
        Etsy.stubs(:environment).returns :production
        Etsy.stubs(:host).returns 'production'
        Etsy.stubs(:api_key).returns('key')
        Etsy.stubs(:api_secret).returns('secret')
        Etsy.stubs(:permission_scopes).returns(['scope_one', 'scope_two'])

        OAuth::Consumer.stubs(:new).with('key', 'secret', {
          :site               => 'https://production',
          :request_token_path => '/v2/oauth/request_token?scope=scope_one+scope_two',
          :access_token_path  => '/v2/oauth/access_token',
        }).returns('consumer')

        client = SecureClient.new

        client.consumer.should == 'consumer'
      end



      should "be able to generate a request token" do
        Etsy.stubs(:callback_url).with().returns('callback_url')
        consumer = stub() {|c| c.stubs(:get_request_token).with(:oauth_callback => 'callback_url').returns('toke') }

        client = SecureClient.new
        client.stubs(:consumer).returns(consumer)

        client.request_token.should == 'toke'
      end

      context "with request data" do
        setup do
          @client = SecureClient.new(:request_token => 'toke', :request_secret => 'secret', :verifier => 'verify')
          @client.stubs(:consumer).returns('consumer')
        end

        should "be able to generate an oauth client" do
          request_token = stub()
          request_token.stubs(:get_access_token).with(:oauth_verifier => 'verify').returns('client')

          OAuth::RequestToken.stubs(:new).with('consumer', 'toke', 'secret').returns(request_token)

          @client.client_from_request_data.should == 'client'
        end

        should "know to generate a client from request data" do
          @client.stubs(:client_from_request_data).returns('client')
          @client.client.should == 'client'
        end
      end

      context "with access data" do
        setup do
          @client = SecureClient.new(:access_token => 'toke', :access_secret => 'secret')
          @client.stubs(:consumer).returns('consumer')
        end

        should "know the :access_token" do
          @client.access_token.should == 'toke'
        end

        should "know the access secret" do
          @client.access_secret.should == 'secret'
        end

        should "be able to generate an oauth client" do
          OAuth::AccessToken.stubs(:new).with('consumer', 'toke', 'secret').returns('client')
          @client.client_from_access_data.should == 'client'
        end

        should "be able to generate a client" do
          @client.stubs(:client_from_access_data).returns('client')
          @client.client.should == 'client'
        end
      end

      context "with a client" do
        setup do
          @client = SecureClient.new
          @client.stubs(:client).returns(stub(:token => 'toke', :secret => 'secret'))
        end

        should "know the access token" do
          @client.access_token.should == 'toke'
        end

        should "know the access_secret" do
          @client.access_secret.should == 'secret'
        end
      end

      should "delegate :get to :client" do
        url = 'http://etsy.com/'

        oauth_client = stub()
        oauth_client.stubs(:get).with(url).returns('something')

        client = SecureClient.new
        client.stubs(:client).returns(oauth_client)

        client.get(url).should == 'something'
      end

    end

  end
end
