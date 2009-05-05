module Etsy
  
  # = Image
  #
  # Represents an image resource of an Etsy listing and contains multiple sizes. 
  # Sizes available are:
  #
  # [small_square] The smallest square image (25x25 pixels)
  # [medium_square] The medium square image (50x50 pixels)
  # [large_square] The largest square image (75x75 pixels)
  # [small] The small image for this listing (155x125 pixels)
  # [medium] The medium image for this listing (200x200 pixels)
  # [large] The largest image available for this listing (430x? pixels)
  #
  class Image
    
    include Etsy::Model
  
    attribute :small_square, :from => :image_url_25x25
    attribute :medium_square, :from => :image_url_50x50
    attribute :large_square, :from => :image_url_75x75 
    attribute :small, :from => :image_url_155x125
    attribute :medium, :from => :image_url_200x200
    attribute :large, :from => :image_url_430xN

  end
end