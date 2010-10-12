require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class AuthorizationTest < Test::Unit::TestCase

    context "The Authorization class in read-only mode" do
      setup do
        Etsy.instance_variable_set(:@environment, :sandbox)
        Etsy.instance_variable_set(:@access_mode, :read_only)
      end

      should "raise an error if you try to initiate an authorization" do
        Etsy.api_key = 'key'
        Etsy.api_secret = 'secret'
        lambda { Authorization.consumer }.should raise_error Etsy::Error
      end
    end

    context "The Authorization class in read-write mode" do
      setup do
        Etsy.instance_variable_set(:@environment, nil)
        Etsy.instance_variable_set(:@access_mode, :read_write)
        Authorization.instance_variable_set(:@callback, nil)
      end

      should "know the authorize url" do
        Authorization::AUTHORIZE_URL.should == 'https://www.etsy.com/oauth/signin'
      end

      should "know the request token path in sandbox mode" do
        Etsy.stubs(:environment).returns(:sandbox)
        Authorization.request_token_path.should == '/v2/sandbox/oauth/request_token'
      end

      should "know the request token path in production mode" do
        Etsy.stubs(:environment).returns(:production)
        Authorization.request_token_path.should == '/v2/oauth/request_token'
      end

      should "know the access token path in sandbox mode" do
        Etsy.stubs(:environment).returns(:sandbox)
        Authorization.access_token_path.should == '/v2/sandbox/oauth/access_token'
      end

      should "know the access token path in production mode" do
        Etsy.stubs(:environment).returns(:production)
        Authorization.access_token_path.should == '/v2/oauth/access_token'
      end

      should "default callback to out of bounds" do
        Authorization.callback.should == "oob"
      end

      should "be able to set and retrieve callback" do
        Authorization.callback = "somewhere else"
        Authorization.callback.should == "somewhere else"
      end

      should "bail if trying to get a consumer without an api key" do
        Etsy.api_key = nil
        Etsy.api_secret = 'secret'
        lambda { Authorization.consumer }.should raise_error ArgumentError
      end

      should "bail if trying to get a consumer without an api secret" do
        Etsy.api_key = 'key'
        Etsy.api_secret = nil
        lambda { Authorization.consumer }.should raise_error ArgumentError
      end

      should "provide a consumer given key and secret" do
        Etsy.api_key = 'key'
        Etsy.api_secret = 'secret'
        Authorization.consumer.class.name.should == "OAuth::Consumer"
      end

    end
  end
end
