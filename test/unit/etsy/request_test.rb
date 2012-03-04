require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class RequestTest < Test::Unit::TestCase

    context "The Request class" do

      should "be able to retrieve a response" do
        http_response = stub()
        response      = stub()

        Response.expects(:new).with(http_response).returns(response)

        request = mock {|m| m.expects(:get).with().returns(http_response) }
        Request.expects(:new).with('/user', :one => 'two').returns(request)

        Request.get('/user', :one => 'two').should == response
      end

      should "require OAuth credentials if :require_secure is set" do
        lambda do
          Request.new('/path', :require_secure => true)
        end.should raise_error(/Secure connection required/)
      end
    end

    context "An instance of the Request class" do

      should "know the base path" do
        Request.new('').base_path.should == '/v2'
      end

      should "append the api_key to the parameters in basic mode" do
        Etsy.expects(:api_key).with().returns('key')
        Request.stubs(:secure?).returns(false)

        r = Request.new('/user', :limit => '1')
        r.parameters.should == {:limit => '1', :api_key => 'key'}
      end

      should "not append the api_key to the parameters in secure mode" do
        Etsy.stubs(:access_mode).returns(:authenticated)

        r = Request.new('/user', :limit => '1', :access_token => 'token', :access_secret => 'secret')
        r.parameters.should == {:limit => '1'}
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

      should "be able to request a single association" do
        r = Request.new('/foo', {:includes => 'Thunder'})
        r.stubs(:parameters).with().returns({:a => :b})
        r.query.should == 'a=b&includes=Thunder'
      end

      should "be able make simplified association requests" do
        r = Request.new('/foo', {:includes => ['Thunder', 'Lightning']})
        r.stubs(:parameters).with().returns({:a => :b})
        r.query.should == 'a=b&includes=Thunder%2CLightning'
      end

      should "be able to generate detailed association queries" do
        r = Request.new('/foo')
        r.association(:resource => 'Lightning').should == 'Lightning'
      end

      should "be able to specify fields in association query" do
        r = Request.new('/foo')
        params = {:resource => 'Lightning', :fields => ['one', 'two']}
        r.association(params).should == 'Lightning(one,two)'
      end

      should "be able to specify limit in association query" do
        r = Request.new('/foo')
        params = {:resource => 'Lightning', :limit => 3}
        r.association(params).should == 'Lightning:3:0'
      end

      should "be able to specify offset in association query" do
        r = Request.new('/foo')
        params = {:resource => 'Lightning', :offset => 7}
        r.association(params).should == 'Lightning:25:7'
      end

      should "be able to join multiple resources in association query" do
        params = {
          :a => 'b',
          :includes => [
            {:resource => 'Lightning'},
            {:resource => 'Thunder'}
          ]
        }
        r = Request.new('/foo', params)
        r.stubs(:base_path).with().returns('/base')
        r.stubs(:parameters).with().returns(:a => 'b')
        r.endpoint_url.should == '/base/foo?a=b&includes=Lightning%2CThunder'
      end

      should "be able to determine the endpoint URI when in read-only mode" do
        r = Request.new('/user')
        r.stubs(:base_path).with().returns('/base')
        r.stubs(:query).with().returns('a=b')

        r.endpoint_url.should == '/base/user?a=b'
      end

      should "be able to determine the endpoint URI when in authenticated mode" do
        Etsy.stubs(:access_mode).returns(:authenticated)

        r = Request.new('/user', :access_token => 'toke', :access_secret => 'secret')
        r.stubs(:base_path).with().returns('/base')
        r.stubs(:query).with().returns('a=b')

        r.endpoint_url.should == '/base/user?a=b'
      end

      should "know the client for read-only mode" do
        Etsy.stubs(:access_mode).returns(:read_only)
        Etsy.stubs(:host).returns('example.com')

        BasicClient.stubs(:new).with('example.com').returns('client')

        r = Request.new('')

        r.client.should == 'client'
      end

      should "know the client for authenticated mode when there is no access token information" do
        Etsy.stubs(:access_mode).returns(:authenticated)
        Etsy.stubs(:host).returns('example.com')

        BasicClient.stubs(:new).with('example.com').returns('client')

        r = Request.new('')

        r.client.should == 'client'
      end

      should "know the client for authenticated mode when there is access token information" do
        Etsy.stubs(:access_mode).returns(:authenticated)
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

      should "not modify the options hash passed to it" do
        options = { :includes => 'Lightning',
                    :access_token => 'token',
                    :access_secret => 'secret',
                    :fields => [:id],
                    limit: 100,
                    offset: 100 }
        options_copy = options.dup

        Request.new('', options)

        options.should == options_copy
      end

    end


  end
end
