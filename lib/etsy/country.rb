module Etsy
  class Country
    include Etsy::Model

    attribute :id, :from => :country_id
    attributes :iso_country_code, :world_bank_country_code
    attributes :name, :slug, :lat, :lon

    def self.find_all
      get("/countries")
    end

    def self.find(id)
      get("/countries/#{id}")
    end

    def self.find_by_alpha2(alpha2)
      alpha2 = alpha2.upcase
      find_all.detect { |country| country.iso_country_code == alpha2}
    end

    def self.find_by_world_bank_country_code(world_bank_country_code)
      world_bank_country_code = world_bank_country_code.upcase
      find_all.detect { |country| country.world_bank_country_code == world_bank_country_code}
    end
  end
end
