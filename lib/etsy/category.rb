module Etsy

  # = Category
  #
  # A category of listings for sale, formed from 1 to 3 tags.
  #
  # A category has the following attributes:
  #
  # [page_description] A short description of the category from the category's landing page
  # [page_title] The title of the category's landing page
  # [category_name] The category's string ID
  # [short_name] A short display name for the category
  # [long_name] A longer display name for the category
  # [children_count] The number of subcategories below this one
  #
  class Category

    include Etsy::Model

    attribute :id, :from => :category_id
    attribute :children_count, :from => :num_children
    attributes :page_description, :page_title, :category_name, :short_name,
               :long_name

    # Retrieve one or more top-level categories by name:
    #
    #   Etsy::Category.find('accessories')
    #
    # You can find multiple top-level categories by passing an array of identifiers:
    #
    #   Etsy::Category.find(['accessories', 'art'])
    #
    def self.find_top(*identifiers_and_options)
      self.find_one_or_more('categories', identifiers_and_options)
    end

    # Retrieve a list of all subcategories of the specified category.
    #
    #   Etsy::Category.find_all_subcategories('accessories')
    #
    # You can also find the subcategories of a subcategory.
    #
    #   Etsy::Category.find_all_subcategories('accessories/apron')
    #
    # Etsy categories only go three levels deep, so this will return nil past the third level.
    #
    #   Etsy::Category.find_all_subcategories('accessories/apron/women')
    #   => nil
    #
    def self.find_all_subcategories(category, options = {})
      valid?(category) ? self.get_all("/taxonomy/categories/#{category}", options) : nil
    end

    def self.find(tag)
      get("/categories/#{tag}")
    end

    # Retrieve a list of all top-level categories.
    #
    #   Etsy::Category.all
    #
    def self.all_top(options = {})
      self.get_all("/taxonomy/categories", options)
    end

    # The collection of active listings associated with this category.
    #
    def active_listings
      @active_listings ||= Listing.find_all_active_by_category(category_name)
    end

    # The collection of subcategories associated with this category.
    #
    def subcategories
      @subcategories ||= Category.find_all_subcategories(category_name)
    end

    private

    def self.valid?(parent_category)
      parent_category.count("/") < 2
    end
  end
end
