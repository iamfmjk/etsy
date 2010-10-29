require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class RequestTest < Test::Unit::TestCase

    context "The Request class" do

      should "know the base URL for the sandbox read-only environment" do
        Etsy.stubs(:environment).returns(:sandbox)
        Etsy.stubs(:access_mode).returns(:read_only)
        Request.base_url.should == 'http://openapi.etsy.com/v2/sandbox/public'
      end

      should "know the base URL for the sandbox read/write environment" do
        Etsy.stubs(:environment).returns(:sandbox)
        Etsy.stubs(:access_mode).returns(:read_write)
        Request.base_url.should == 'http://openapi.etsy.com/v2/sandbox/private'
      end

      should "know the base URL for the production read-only environment" do
        Etsy.stubs(:environment).returns(:production)
        Etsy.stubs(:access_mode).returns(:read_only)
        Request.base_url.should == 'http://openapi.etsy.com/v2/public'
      end

      should "know the base URL for the production read-write environment" do
        Etsy.stubs(:environment).returns(:production)
        Etsy.stubs(:access_mode).returns(:read_write)
        Request.base_url.should == 'http://openapi.etsy.com/v2/private'
      end

      should "be able to retrieve a response" do
        http_response = stub()
        response      = stub()

        Response.expects(:new).with(http_response).returns(response)

        request = mock {|m| m.expects(:get).with().returns(http_response) }
        Request.expects(:new).with('/user', :one => 'two').returns(request)

        Request.get('/user', :one => 'two').should == response
      end
    end

    context "An instance of the Request class" do

      should "append the api_key and detail_level to the parameters" do
        Etsy.expects(:api_key).with().returns('key')

        r = Request.new('/user', :limit => '1')
        r.parameters.should == {:limit => '1', :api_key => 'key', :detail_level => 'high'}
      end

      should "be able to generate query parameters" do
        r = Request.new('/user')
        r.expects(:parameters).with().returns(:api_key => 'foo')
        r.query.should == 'api_key=foo'
      end

      should "be able to join multiple query parameters" do
        params = {:limit => '1', :other => 'yes'}

        r = Request.new('/user', params)
        r.stubs(:parameters).with().returns(params)

        r.query.split('&').sort.should == %w(limit=1 other=yes)
      end

      should "be able to determine the endpoint URI" do
        Request.stubs(:base_url).with().returns('http://example.com')

        r = Request.new('/user')
        r.stubs(:query).with().returns('a=b')

        r.endpoint_uri.to_s.should == 'http://example.com/user?a=b'
      end

      should "be able to make a successful request" do
        uri = URI.parse('http://example.com')
        response = stub()

        r = Request.new('/user')
        r.expects(:endpoint_uri).with().returns(uri)

        Net::HTTP.expects(:get).with(uri).returns(response)

        r.get.should == response
      end

    end


  end
end
