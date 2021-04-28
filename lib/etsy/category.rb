module Etsy
  class Category
    include Etsy::Model

    attribute :id
    attributes :level, :name, :parent, :parent_id, :path, :category_id, :children, :children_ids, :full_path_taxonomy_ids

    def self.get_buyer_taxonomy
      get_all('/taxonomy/buyer/get')
    end

    def self.get_seller_taxonomy
      get_all('/taxonomy/seller/get')
    end

    def self.get_seller_taxonomy_version
      get('/taxonomy/seller/version')
    end

    def taxonomy_node_property
      get_all("/taxonomy/seller/#{id}/properties")
    end

    def self.taxonomy_node_property(taxonomy_id)
      get_all("/taxonomy/seller/#{taxonomy_id}/properties")
    end
  end
end
