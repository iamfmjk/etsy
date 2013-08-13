module Etsy

  # = BasicClient
  #
  # Used for calling public API methods.
  #
  class BasicClient

    # Create a new client that will connect to the specified host
    #
    def initialize
      @host = Etsy.host
    end

    def client # :nodoc:
      if @client
        return @client
      else
        @client = Net::HTTP.new(@host, Etsy.protocol == "http" ? 80 : 443)
        @client.use_ssl = true if Etsy.protocol == "https"
        return @client
      end
    end

    # Fetch a raw response from the specified endpoint
    #
    def get(endpoint)
      client.get(endpoint)
    end

  end
end
