module Etsy
  class About
    include Etsy::Model

    attributes :shop_id, :status, :story_headline, :story_leading_paragraph,
               :story, :related_links, :url

    def self.find_by_shop(shop)
      get("/shops/#{shop.id}/about")
    end

  end
end
