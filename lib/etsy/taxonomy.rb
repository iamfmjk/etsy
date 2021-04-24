module Etsy
  class Taxonomy
    include Etsy::Model

    attribute :id
    attributes :level, :name, :parent, :parent_id, :path, :category_id, :children, :children_ids, :full_path_taxonomy_ids

    def get_buyer_taxonomy
      get('/taxonomy/buyer/get')
    end

    def get_seller_taxonomy
      get('/taxonomy/seller/get')
    end

    def get_seller_taxonomy_version
      get('/taxonomy/seller/version')
    end
  end
end