module Etsy

  # = Image
  #
  # Represents an image resource of an Etsy listing and contains multiple sizes.
  # Sizes available are:
  #
  # [square] The square image thumbnail (75x75 pixels)
  # [small] The small image thumbnail (170x135 pixels)
  # [thumbnail] The thumbnail for the image, no more than 570px wide
  # [full] The full image for this listing, no more than 1500px wide
  #
  class Image

    include Etsy::Model

    attribute :id, :from => :listing_image_id
    attribute :square, :from => :url_75x75
    attribute :small, :from => :url_170x135
    attribute :thumbnail, :from => :url_570xN
    attribute :height, :from => :full_height
    attribute :width, :from => :full_width
    attribute :full, :from => :url_fullxfull

    # Fetch all images for a given listing.
    #
    def self.find_all_by_listing_id(listing_id, options = {})
      get_all("/listings/#{listing_id}/images", options)
    end

    def self.create(listing, image_path, options = {})
      options.merge!(:require_secure => true)
      options[:image] = File.new(image_path)
      options[:multipart] = true
      post("/listings/#{listing.id}/images", options)
    end

    # Delete image
    #
    def self.destroy(listing, image, options = {})
      options.merge!(:require_secure => true)
      delete("/listings/#{listing.id}/images/#{image.id}", options)
    end
  end
end
