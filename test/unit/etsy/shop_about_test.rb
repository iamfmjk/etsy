require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class AboutTest < Test::Unit::TestCase
    context "An instance of the About class" do
      setup do
        data = read_fixture('about/getAbout.json')
        @about = About.new(data.first)
      end

      should "have a shop id" do
        @about.shop_id.should == 8740774
      end

      should "have a status" do
        @about.status.should == "active"
      end

      should "have a story_headline" do
        @about.story_headline.should == 'A shop long in the making...'
      end

      should "have a story_leading_paragraph" do
        @about.story_leading_paragraph.should == 'This is the leading paragraph'
      end

      should "have a story" do
        @about.story.should == "I grew up with strong women in my family who all had a love of creating. My mom and grandma always encouraged a lifelong love of creating  Working with glass, wire, and mineral components brings back my graduate school days, when I studied these items from a scientific point-of-view. Here&#39;s hoping I can create something that gives you a little sparkle in your life!"
      end

      should "have a related_links" do
        @about.related_links.should == {
          "link-0"=> {"title"=> "facebook", "url"=> "https://www.facebook.com/pebbleplusmetal/"},
          "link-1"=> {"title"=> "pinterest", "url"=> "https://www.pinterest.com/PebblePlusMetal/pebble%2Bmetal/"}
        }
      end

      should "have a url" do
        @about.url.should == 'https://www.etsy.com/shop/PebblePlusMetal/about'
      end
    end
  end
end
