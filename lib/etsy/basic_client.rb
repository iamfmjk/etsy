module Etsy
  class BasicClient

    def initialize(host)
      @host = host
    end

    def client
      @client ||= Net::HTTP.new(@host)
    end

    def get(endpoint)
      client.get(endpoint)
    end

  end
end