require 'spec_helper'

module Etsy
  describe Client do
    subject do
      Client.new(
        :api_key    => Etsy::Test::API_KEY,
        :api_secret => Etsy::Test::API_SECRET
      )
    end

    describe "#user" do
      use_vcr_cassette

      it "should be able to find a user" do
        subject.user("jonS2011").should == {
          "user_id"             => 17974443,
          "login_name"          => "jonS2011",
          "creation_tsz"        => 1322586362,
          "referred_by_user_id" => nil,
          "feedback_info"       => {
            "count" => 0,
            "score" => nil
          }
        }
      end
    end

    context "oauth authentication" do
      describe "#request_token" do
        use_vcr_cassette

        it "should be able to get a request token" do
          subject.request_token.should be_a(OAuth::RequestToken)
        end
      end

      describe "#oauth_token" do
        use_vcr_cassette :record => :new_episodes

        it "should be able to get an oauth token" do
          request_token = subject.request_token
          p request_token.params[:login_url]
          verifier      = Etsy::Test::OAUTH_VERIFIER
          subject.oauth_token(request_token, verifier).should == [Etsy::Test::OAUTH_TOKEN, Etsy::Test::OAUTH_SECRET]
        end
      end
    end

    describe "#myself" do
      use_vcr_cassette
      before(:each) do
        subject.oauth_token  = Etsy::Test::OAUTH_TOKEN
        subject.oauth_secret = Etsy::Test::OAUTH_SECRET
      end

      it "should be able to find the authenticated user" do
        subject.myself.should == {
          "user_id"             => 17974443,
          "login_name"          => "jonS2011",
          "primary_email"       => "example@example.com",
          "creation_tsz"        => 1322586362,
          "referred_by_user_id" => nil,
          "feedback_info"       => {
            "count" => 0,
            "score" => nil
          }
        }
      end
    end

    describe "#get" do
      use_vcr_cassette

      it "should be able to get an api endpoint" do
        subject.get('users', :keywords => "jonS2011").body.should == {
         "count" => 1,
         "pagination" => {"effective_limit"=>25, "effective_offset"=>0, "next_offset"=>nil, "effective_page"=>1, "next_page"=>nil},
         "params" => {"keywords"=>"jonS2011", "limit"=>25, "offset"=>0, "page"=>nil},
         "results" => [{"user_id"=>17974443, "login_name"=>"jonS2011", "creation_tsz"=>1322586362, "referred_by_user_id"=>nil, "feedback_info"=>{"count"=>0, "score"=>nil}}],
         "type" => "User"
        }
      end
    end
  end
end
