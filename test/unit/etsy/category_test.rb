require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class CategoryTest < Test::Unit::TestCase

    context "The Category class" do

      should "be able to find a single top-level category" do
        categories = mock_request('/categories/accessories', {}, 'Category', 'getCategory.single.json')
        Category.find_top('accessories').should == categories.first
      end

      should "be able to find multiple categories" do
        categories = mock_request('/categories/accessories,art', {}, 'Category', 'getCategory.multiple.json')
        Category.find_top('accessories', 'art').should == categories
      end

      should "be able to find all top-level categories" do
        categories = mock_request('/taxonomy/categories', {}, 'Category', 'findAllTopCategory.json')
        Category.all_top.should == categories
      end

      should "return an array of categories if there is only 1 result returned" do
        categories = mock_request('/taxonomy/categories', {}, 'Category', 'findAllTopCategory.single.json')
        Category.all_top.should == categories
      end

      context "within the scope of a top-level category" do

        should "be able to find all subcategories" do
          categories = mock_request('/taxonomy/categories/accessories', {}, 'Category', 'findAllTopCategoryChildren.json')
          Category.find_all_subcategories('accessories').should == categories
        end

        should "be able to find the subcategories of a subcategory" do
          categories = mock_request('/taxonomy/categories/accessories/apron', {}, 'Category', 'findAllSubCategoryChildren.json')
          Category.find_all_subcategories('accessories/apron').should == categories
        end

        should "return nil when trying to find the subcategories of a subcategory of a subcategory" do
          Category.find_all_subcategories('accessories/apron/women').should be_nil
        end

      end

    end

    context "An instance of the Category class" do

      context "with response data" do
        setup do
          data = read_fixture('category/getCategory.single.json')
          @category = Category.new(data.first)
        end

        should "have a value for :id" do
          @category.id.should == 69150467
        end

        should "have a value for :page_description" do
          @category.page_description.should == "Shop for unique, handmade accessories from our artisan community"
        end

        should "have a value for :page_title" do
          @category.page_title.should == "Handmade accessories"
        end

        should "have a value for :category_name" do
          @category.category_name.should == "accessories"
        end

        should "have a value for :short_name" do
          @category.short_name.should == "Accessories"
        end

        should "have a value for :long_name" do
          @category.long_name.should == "Accessories"
        end

        should "have a value for :children_count" do
          @category.children_count.should == 27
        end
      end

      should "have a collection of active listings" do
        category = Category.new
        category.stubs(:category_name).with().returns('accessories')

        Listing.stubs(:find_all_active_by_category).with('accessories').returns('listings')

        category.active_listings.should == 'listings'
      end

      should "have a collection of subcategories" do
        category = Category.new
        category.stubs(:category_name).with().returns('accessories')

        Category.stubs(:find_all_subcategories).with('accessories').returns('categories')

        category.subcategories.should == 'categories'
      end

    end

  end
end
