module Etsy
  class About
    include Etsy::Model

    attributes :status, :story_headline, :story_leading_paragraph,
               :story, :related_links, :url
    attribute :id, :from => :shop_id
    attribute :shop_id, :from => :shop_id

    def self.find_by_shop(shop)
      get("/shops/#{shop.id}/about")
    end

  end
end
