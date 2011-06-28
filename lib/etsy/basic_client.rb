module Etsy

  # = BasicClient
  #
  # Used for calling public API methods.
  #
  class BasicClient

    # Create a new client that will connect to the specified host
    #
    def initialize(host)
      @host = host
    end

    def client # :nodoc:
      @client ||= Net::HTTP.new(@host)
    end

    # Fetch a raw response from the specified endpoint
    #
    def get(endpoint)
      client.get(endpoint)
    end

  end
end
