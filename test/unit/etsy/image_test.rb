require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ImageTest < Test::Unit::TestCase

    context "The Image class" do

      context "without oauth" do
        should "be able to find all images for a listing" do
          images = mock_request('/listings/1/images', {}, 'Image', 'findAllListingImages.json')
          Image.find_all_by_listing_id(1, {}).should == images
        end
      end

      context "with options" do
        should "be able to find all images for a listing with options in request" do
          images = mock_request('/listings/1/images', {foo: "bar"}, 'Image', 'findAllListingImages.json')
          Image.find_all_by_listing_id(1, {foo: "bar"}).should == images
        end
      end
    end

    context "An instance of the Image class" do

      context "with response data" do
        setup do
          data = read_fixture('image/findAllListingImages.json')
          @image = Image.new(data.first)
        end

        should "have a value for :id" do
          @image.id.should == 185073072
        end

        should "have a value for :square" do
          @image.square.should == "http://ny-image0.etsy.com/il_75x75.185073072.jpg"
        end

        should "have a value for :small" do
          @image.small.should == "http://ny-image0.etsy.com/il_170x135.185073072.jpg"
        end

        should "have a value for :thumbnail" do
          @image.thumbnail.should == "http://ny-image0.etsy.com/il_570xN.185073072.jpg"
        end

        should "have a value for :full" do
          @image.full.should == "http://ny-image0.etsy.com/il_fullxfull.185073072.jpg"
        end
      end

    end

  end
end