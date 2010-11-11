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

    attribute :square, :from => :url_75x75
    attribute :small, :from => :url_170x135
    attribute :thumbnail, :from => :url_570xN
    attribute :full, :from => :url_fullxfull

    # Fetch all images for a given listing.
    #
    def self.find_all_by_listing_id(listing_id)
      response = Request.get("/listings/#{listing_id}/images")
      [response.result].flatten.map {|data| new(data) }
    end

  end
end