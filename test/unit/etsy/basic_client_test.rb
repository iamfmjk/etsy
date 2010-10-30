require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class BasicClientTest < Test::Unit::TestCase

    context "An instance of the BasicClient class" do

      should "be able to construct a client" do
        client = BasicClient.new('example.com')
        Net::HTTP.stubs(:new).with('example.com').returns('client')

        client.client.should == 'client'
      end

      should "be able to perform a GET request" do
        http_client = stub()
        http_client.stubs(:get).with('endpoint').returns('response')

        client = BasicClient.new('')
        client.stubs(:client).returns(http_client)

        client.get('endpoint').should == 'response'
      end

    end

  end
end
