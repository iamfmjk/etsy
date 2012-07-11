require 'spec_helper'

module Etsy
  describe Client do
    use_vcr_cassette

    subject { Client.new(:api_key => API_KEY) }

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
