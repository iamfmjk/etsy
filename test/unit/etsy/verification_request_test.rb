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
        client.stubs(:request_token).returns(stub(:params => {:login_url => 'http://www.etsy.com?foo=bar&baz=true'}, :secret => 'secret'))

        @request.stubs(:client).returns(client)

        @request.url.should == 'http://www.etsy.com?foo=bar&baz=true'
      end

    end

  end
end
