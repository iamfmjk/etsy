module Etsy
  class ListingFile
    include Etsy::Model

    attribute :id, :from => :listing_file_id
    attribute :listing_id

    attributes :rank, :filename, :filesize, :size_bytes, :filetype, :create_date

    def self.find_files_by_listing(listing_id, options)
      get_all("/listings/#{listing_id}/files", options)
    end

    def self.upload_listing_file(listing_id, options)
      post("/listings/#{listing_id}/files", options)
    end

    def self.find_listing_file(listing_id, listing_file_id, options)
      get("/listings/#{listing_id}/files/#{listing_file_id}", options)
    end

    def self.delete_listing_file(listing_id, listing_file_id, options)
      delete("/listings/#{listing_id}/files/#{listing_file_id}", options)
    end
  end
end