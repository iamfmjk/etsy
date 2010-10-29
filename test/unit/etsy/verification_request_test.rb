require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class VerificationRequestTest < Test::Unit::TestCase

    context "An instance of the VerificationRequest class" do
      setup { @request = VerificationRequest.new }

      should "have a client" do
        SecureClient.stubs(:new).returns('client')
        @request.client.should == 'client'
      end

      should "know the url" do
        client = stub()
        client.stubs(:request_token).returns(stub(:authorize_url => 'http://www.etsy.com?foo=bar', :secret => 'secret'))

        @request.stubs(:client).returns(client)

        @request.url.should == 'http://www.etsy.com?foo=bar&oauth_consumer_key=secret'
      end

    end

  end
end