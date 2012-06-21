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

      should "have a record count when the response is not paginated" do
        raw_response = mock
        raw_response.stubs(:body => '{ "count": 1 }')
        r = Response.new(raw_response)

        r.count.should == 1
      end

      should "have a record count when the response is paginated" do
        raw_response = mock
        raw_response.stubs(:body => '{ "count": 100, "results": [{},{}], "pagination": {} }')
        r = Response.new(raw_response)

        r.count.should == 2
      end

      should "return a count of 0 when the response is paginated and the results are empty" do
        raw_response = mock
        raw_response.stubs(:body => '{ "count": 100, "results": null, "pagination": {} }')
        r = Response.new(raw_response)

        r.count.should == 0
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
        raw_response.stubs(:body => "I am not JSON")
        r = Response.new(raw_response)

        r.body.should == 'I am not JSON'
      end

      should "raise an invalid JSON exception if the response is not json" do
        raw_response = mock
        raw_response.stubs(:body => "I am not JSON")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::EtsyJSONInvalid)
      end

      should "raise OAuthTokenRevoked" do
        raw_response = mock
        raw_response.stubs(:body => "oauth_problem=token_revoked")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::OAuthTokenRevoked)
      end

      should "raise MissingShopID" do
        raw_response = mock
        raw_response.stubs(:body => "something Shop with PK shop_id something")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::MissingShopID)
      end

      should "raise InvalidUserID" do
        raw_response = mock
        raw_response.stubs(:body => "'someguy' is not a valid user_id")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::InvalidUserID)
      end

      should "raise TemporaryIssue" do
        raw_response = mock
        raw_response.stubs(:body => "something Temporary Etsy issue something")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::TemporaryIssue)

        raw_response = mock
        raw_response.stubs(:body => "something Resource temporarily unavailable something")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::TemporaryIssue)

        raw_response = mock
        raw_response.stubs(:body => "something You have exceeded your API limit something")
        r = Response.new(raw_response)

        lambda { r.to_hash }.should raise_error(Etsy::TemporaryIssue)
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
