require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class RequestTest < Test::Unit::TestCase
    
    describe "The Request class" do

      it "should know the base URL" do
        Request.base_url.should == 'http://beta-api.etsy.com/v1'
      end

      it "should be able to retrieve a response" do
        http_response = stub()
        response      = stub()
        
        Response.expects(:new).with(http_response).returns(response)
        
        request = mock {|m| m.expects(:get).with().returns(http_response) }
        Request.expects(:new).with('/user', :one => 'two').returns(request)
        
        Request.get('/user', :one => 'two').should == response
      end
    end
   
    describe "An instance of the Request class" do

      it "should append the api_key and detail_level to the parameters" do
        Etsy.expects(:api_key).with().returns('key')
        
        r = Request.new('/user', :limit => '1')
        r.parameters.should == {:limit => '1', :api_key => 'key', :detail_level => 'high'}
      end

      it "should be able to generate query parameters" do
        r = Request.new('/user')
        r.expects(:parameters).with().returns(:api_key => 'foo')
        r.query.should == 'api_key=foo'
      end
      
      it "should be able to join multiple query parameters" do
        params = {:limit => '1', :other => 'yes'}
        
        r = Request.new('/user', params)
        r.stubs(:parameters).with().returns(params)
        
        r.query.split('&').sort.should == %w(limit=1 other=yes)
      end
      
      it "should be able to determine the endpoint URI" do
        Request.stubs(:base_url).with().returns('http://example.com')
        
        r = Request.new('/user')
        r.stubs(:query).with().returns('a=b')
        
        r.endpoint_uri.to_s.should == 'http://example.com/user?a=b'
      end
      
      it "should be able to make a successful request" do
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