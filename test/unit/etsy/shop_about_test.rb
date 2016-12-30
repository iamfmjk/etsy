require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class AboutTest < Test::Unit::TestCase
    context "An instance of the About class" do
      setup do
        data = {}
        @about = About.new(data.first)
      end

      should "have a shop id" do
        @about.shop_id.should == 11045327
      end

      should "have a status" do
        @about.status.should == "active"
      end

      should "have a story_headline" do
        @about.story_headline.should == 'A shop long in the making'
      end

      should "have a story_leading_paragraph" do
        @about.story_leading_paragraph.should == 'This is the leading paragraph'
      end

      should "have a story" do
        @about.story.should == 'This is the leading paragraph

        and this is the next one'
      end

      should "have a related_links" do
        @about.related_links.should == ['http://www.facebook.com', 'http://www.instagram.com']
      end

      should "have a url" do
        @about.url.should == 'https://www.etsy.com/shop/PebblePlusMetal#about'
      end
    end
  end
end
