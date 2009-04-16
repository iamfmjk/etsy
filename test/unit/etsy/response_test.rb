require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ResponseTest < Test::Unit::TestCase

    describe "An instance of the Response class" do
      
      it "should be able to decode the JSON data to a hash" do
        data = '{ "foo":"bar" }'
        
        r = Response.new(data)
        r.to_hash.should == {'foo' => 'bar'}
      end
      
      it "should only decode the JSON data once" do
        JSON.expects(:parse).once.returns({})
        
        r = Response.new('{ "foo":"bar" }')
        2.times { r.to_hash }
      end
      
      it "should have a record count" do
        r = Response.new('')
        r.expects(:to_hash).with().returns('count' => 1)
        
        r.count.should == 1
      end
      
      it "should have result data" do
        r = Response.new('')
        r.expects(:to_hash).with().returns('results' => ['foo'])
        
        r.result.should == ['foo']
      end
      
    end


  end
end