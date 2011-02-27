module Etsy

  # = Address
  #
  # Represents a single Etsy Address.  Users may or may not have associated addresses.
  #
  # An address has the following attributes:
  #
  # [first_line] Street address
  # [second_line] Additional street information.
  # [city]
  # [state]
  # [country]
  # [country_id] The Etsy country id
  #
  class Address

    include Etsy::Model

    attributes :name, :first_line, :second_line, :city, :state, :zip, :country_id

    attribute :id, :from => :user_address_id
    attribute :country, :from => :country_name

    # Retrieve all of a user's addresses by user name or ID:
    #
    #   Etsy::Address.find('reagent')
    #
    def self.find(*identifiers_and_options)
      self.append_to_endpoint('addresses', identifiers_and_options)
      self.find_one_or_more('users', identifiers_and_options)
    end

    private
    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end

    def self.append_to_endpoint(suffix, arguments)
      if arguments.last.class == Hash
        arguments.last[:append_to_endpoint] = suffix
      else
        arguments << {:append_to_endpoint => suffix}
      end
    end
  end
end
