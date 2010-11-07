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

    def self.find_all_by_listing_id(listing_id)
      response = Request.get("/listings/#{listing_id}/images")
      [response.result].flatten.map {|data| new(data) }
    end

    attribute :square, :from => :url_75x75
    attribute :small, :from => :url_170x135
    attribute :thumbnail, :from => :url_570xN
    attribute :full, :from => :url_fullxfull

  end
end