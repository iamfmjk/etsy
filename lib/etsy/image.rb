module Etsy
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