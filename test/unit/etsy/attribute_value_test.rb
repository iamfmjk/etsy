require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class AttributeValueTest < Test::Unit::TestCase
    context 'The AttributeValue class' do
      context 'without oauth' do
        should 'be able to find all images for a listing' do
          property_values = mock_request(
            '/listings/1/attributes',
            {},
            'AttributeValue',
            'findAllListingPropertyValues.json'
          )
          AttributeValue.find_all_by_listing_id(1, {}).should == property_values
        end
      end

      context 'with options' do
        should 'be able to find all property_values for a listing with options in request' do
          property_values = mock_request(
            '/listings/1/attributes',
            { foo: 'bar' },
            'AttributeValue',
            'findAllListingPropertyValues.json'
          )
          AttributeValue.find_all_by_listing_id(1, foo: 'bar').should == property_values
        end
      end
    end

    context 'An instance of the AttributeValue class' do
      context 'with response data' do
        setup do
          data = read_fixture('attribute_value/findAllListingPropertyValues.json')
          @primary_color = AttributeValue.new(data[0])
          @secondary_color = AttributeValue.new(data[1])
          @height = AttributeValue.new(data[2])
          @width = AttributeValue.new(data[3])
        end

        should 'have a value for :scale_name for width' do
          @width.scale_name.should == 'Inches'
        end

        should 'have a value for :scale_id for width' do
          @width.scale_id.should == 5
        end

        should 'have a value for :scale_name for height' do
          @height.scale_name.should == 'Inches'
        end

        should 'have a value for :scale_id for height' do
          @height.scale_id.should == 5
        end

        should 'have an array of :values with color name for primary_color' do
          @primary_color.values.should == ['Beige']
        end

        should 'have an array of :values with color name for secondary_color' do
          @secondary_color.values.should == ['Black']
        end
      end
    end
  end
end
