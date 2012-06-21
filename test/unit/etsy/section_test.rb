require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class SectionTest < Test::Unit::TestCase
    context "An instance of the Section class" do
      setup do
        data = read_fixture('section/getShopSection.json')
        @section = Section.new(data.first)
      end

      should "have an id" do
        @section.id.should == 11045327
      end

      should "have an title" do
        @section.title.should == "Blue Items"
      end

      should "have an user_id" do
        @section.user_id.should == 9569349
      end

      should "have an active_listing_count" do
        @section.active_listing_count.should == 7
      end
    end
  end
end
