require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class RequestTest < Test::Unit::TestCase

    context "The Request class" do

      should "know the host" do
        Request.host.should == 'openapi.etsy.com'
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

      should "know the base path for the sandbox read-only environment" do
        Etsy.stubs(:environment).returns(:sandbox)
        Etsy.stubs(:access_mode).returns(:read_only)

        Request.new('').base_path.should == '/v2/sandbox/public'
      end

      should "know the base path for the sandbox read/write environment when the access information is present" do
        Etsy.stubs(:environment).returns(:sandbox)
        Etsy.stubs(:access_mode).returns(:read_write)

        r = Request.new('', :access_token => 'toke', :access_secret => 'secret')
        r.base_path.should == '/v2/sandbox/private'
      end

      should "know the base path for the sandbox read/write environment when the access information is not present" do
        Etsy.stubs(:environment).returns(:sandbox)
        Etsy.stubs(:access_mode).returns(:read_write)

        Request.new('').base_path.should == '/v2/sandbox/public'
      end

      should "know the base path for the production read-only environment" do
        Etsy.stubs(:environment).returns(:production)
        Etsy.stubs(:access_mode).returns(:read_only)

        Request.new('').base_path.should == '/v2/public'
      end

      should "know the base path for the production read-write environment when access information is present" do
        Etsy.stubs(:environment).returns(:production)
        Etsy.stubs(:access_mode).returns(:read_write)

        r = Request.new('', :access_token => 'toke', :access_secret => 'secret')
        r.base_path.should == '/v2/private'
      end

      should "know the base path for the production read-write environment when access information is not present" do
        Etsy.stubs(:environment).returns(:production)
        Etsy.stubs(:access_mode).returns(:read_write)

        Request.new('').base_path.should == '/v2/public'
      end

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

      should "be able to determine the endpoint URI when in read-only mode" do
        r = Request.new('/user')
        r.stubs(:base_path).with().returns('/base')
        r.stubs(:query).with().returns('a=b')

        r.endpoint_url.should == '/base/user?a=b'
      end

      should "be able to determine the endpoint URI when in read-write mode" do
        Etsy.stubs(:access_mode).returns(:read_write)

        r = Request.new('/user', :access_token => 'toke', :access_secret => 'secret')
        r.stubs(:base_path).with().returns('/base')
        r.stubs(:query).with().returns('a=b')

        r.endpoint_url.should == '/base/user?a=b'
      end

      should "know the client for read-only mode" do
        Etsy.stubs(:access_mode).returns(:read_only)
        Request.stubs(:host).returns('example.com')

        BasicClient.stubs(:new).with('example.com').returns('client')

        r = Request.new('')

        r.client.should == 'client'
      end

      should "know the client for read-write mode when there is no access token information" do
        Etsy.stubs(:access_mode).returns(:read_write)
        Request.stubs(:host).returns('example.com')

        BasicClient.stubs(:new).with('example.com').returns('client')

        r = Request.new('')

        r.client.should == 'client'
      end

      should "know the client for read-write mode when there is access token information" do
        Etsy.stubs(:access_mode).returns(:read_write)
        SecureClient.stubs(:new).with(:access_token => 'toke', :access_secret => 'secret').returns('client')

        r = Request.new('', :access_token => 'toke', :access_secret => 'secret')
        r.client.should == 'client'
      end

      should "be able to make a successful request" do
        client = stub()
        client.stubs(:get).with('endpoint_url').returns('response')

        r = Request.new('/user')
        r.stubs(:endpoint_url).with().returns('endpoint_url')
        r.stubs(:client).returns(client)

        r.get.should == 'response'
      end

    end


  end
end
