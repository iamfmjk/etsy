module Etsy
  module Variation
    class PropertySet
      # Used to find properties which the seller can vary (eg Size, Color, etc), and options associated with those properties (eg Inches)
      #
      # The variations stuff is complex. See https://www.etsy.com/developers/documentation/getting_started/variations for more info.
      #
      # Probably the most useful method here is qualifying_properties_for_property. This method pulls in data from a few sources to get
      # you everything you need to set up your variation options.
      #
      # Eg: I want to have a few Length options on my listings, and I want to use the unit Inches, then:
      #   Etsy::Variation::PropertySet.qualifying_properties_for_property("Length")
      #   => [{
      #        "param"=>"sizing_scale",
      #        "description"=>"Sizing Scale",
      #        "options"=>{
      #          "Alpha" => 301,
      #          "Inches" => 327,
      #          "Centimeters" => 328,
      #          "Fluid Ounces" => 335,
      #          "Millilitres" => 336,
      #          "Litres" => 337,
      #          "Other => 329
      #        }
      #      }]
      #
      #  This tells me I want to set the parameter sizing_scale to 327 when calling Etsy::Listing.add_variations.

      include Etsy::Model


      attributes :properties, :category_id, :options, :qualifiers,
                 :qualifying_properties

      def self.all
        @all ||= get("/property_sets")
      end

      def self.find_property_by_name(name)
        property = all.properties.detect {|prop_id, prop| prop["name"] == name}
        if property
          property_id, property_data = property
          property_data
        end
      end

      def self.qualifying_properties_for_property(name)
        property = find_property_by_name(name)
        return nil unless property
        property_id = property["property_id"]

        qualifiers = all.qualifiers[property_id.to_s]
        return [] unless qualifiers

        qualifiers.map do |qualifier|
          qualifying_properties = all.qualifying_properties[qualifier.fetch("property_id").to_s]
          options = qualifier.fetch("options").inject({}) do |acc, opt_id|
            acc.merge({
              all.options.fetch(opt_id.to_s) => opt_id
            })
          end
          {
            "param" => qualifying_properties.fetch("param"),
            "description" => qualifying_properties.fetch("description"),
            "options" => options
          }
        end
      end
    end
  end
end
