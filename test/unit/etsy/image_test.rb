require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ImageTest < Test::Unit::TestCase
    
    describe "An instance of the Image class" do

      when_populating Image, :from => lambda { read_fixture('getShopListings')[0]['all_images'].first } do

        value_for :small_square,  :is => "http://ny-image2.etsy.com/il_25x25.67765346.jpg"
        value_for :medium_square, :is => "http://ny-image2.etsy.com/il_50x50.67765346.jpg"
        value_for :large_square,  :is => "http://ny-image2.etsy.com/il_75x75.67765346.jpg"
        value_for :small,         :is => "http://ny-image2.etsy.com/il_155x125.67765346.jpg"
        value_for :medium,        :is => "http://ny-image2.etsy.com/il_200x200.67765346.jpg"
        value_for :large,         :is => "http://ny-image2.etsy.com/il_430xN.67765346.jpg"
        
      end
      
    end
    
  end
end