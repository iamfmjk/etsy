require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ResponseTest < Test::Unit::TestCase

    context "An instance of the Response class" do

      should "be able to decode the JSON data to a hash" do
        data = '{ "foo":"bar" }'

        r = Response.new(stub(:body => data))
        r.to_hash.should == {'foo' => 'bar'}
      end

      should "only decode the JSON data once" do
        JSON.expects(:parse).once.returns({})

        r = Response.new(stub(:body => '{ "foo":"bar" }'))
        2.times { r.to_hash }
      end

      should "have a record count" do
        r = Response.new('')
        r.expects(:to_hash).with().returns('count' => 1)

        r.count.should == 1
      end

      should "return an array if there are multiple results entries" do
        r = Response.new('')
        r.expects(:code).with().returns('200')
        r.expects(:count).with().returns(2)
        r.expects(:to_hash).with().returns('results' => %w(one two))

        r.result.should == %w(one two)
      end

      should "return a single value for results if there is only 1 result" do
        r = Response.new('')
        r.expects(:code).with().returns('200')
        r.expects(:count).with().returns(1)
        r.expects(:to_hash).with().returns('results' => ['foo'])

        r.result.should == 'foo'
      end

      should "provide the complete raw body" do
        raw_response = mock
        raw_response.expects(:body => "I am not JSON")
        r = Response.new(raw_response)

        r.body.should == 'I am not JSON'
      end

      should "provide the code" do
        raw_response = mock
        raw_response.expects(:code => "400")
        r = Response.new(raw_response)

        r.code.should == '400'
      end

      should "consider a code of 2xx successful" do
        raw_response = mock

        raw_response.expects(:code => "200")
        r = Response.new(raw_response)
        r.should be_success

        raw_response.expects(:code => "201")
        r = Response.new(raw_response)
        r.should be_success
      end

      should "consider a code of 4xx unsuccessful" do
        raw_response = mock

        raw_response.expects(:code => "404")
        r = Response.new(raw_response)
        r.should_not be_success
      end

      should "consider a code of 5xx unsuccessful" do
        raw_response = mock

        raw_response.expects(:code => "500")
        r = Response.new(raw_response)
        r.should_not be_success
      end
    end


  end
end
