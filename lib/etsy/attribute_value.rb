module Etsy

  # = AttributeValue
  #
  # An attribute of a listing according to its taxonomy.
  #
  # An attribute has the following attributes:
  #
  # [property_id]	  (INT)           The numeric ID of this property.
  # [property_name] (STRING)	      The name of the property, in the requested locale language.
  # [scale_id]      (INT)	          The numeric ID of the scale (if any).
  # [scale_name]    (STRING)	      The label used to describe the chosen scale (if any).
  # [value_ids]     (Array(INT))    The numeric IDs of the values.
  # [values]        (Array(STRING)) The literal values of the value
  class AttributeValue

    include Etsy::Model

    attribute :id, :from => :property_id
    attributes :property_name, :scale_id, :scale_name, :value_ids,
               :values

    # Fetch all property_values for a given listing.
    #
    def self.find_all_by_listing_id(listing_id, options = {})
      get_all("/listings/#{listing_id}/attributes", options)
    end

    # Adds a new attribute_value to the listing given
    #
    def self.create(listing, property_hash, options = {})
      property_id = property_hash[:property_id]
      options.merge!(:require_secure => true)
      options.merge!(property_hash)
      put("/listings/#{listing.id}/attributes/#{property_id}", options)
    end

    # Delete attribute_value from listing
    #
    def self.destroy(listing, property_value, options = {})
      options.merge!(:require_secure => true)
      delete("/listings/#{listing.id}/attributes/#{property_value.id}", options)
    end
  end
end

