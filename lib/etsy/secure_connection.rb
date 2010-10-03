module Etsy
  class SecureConnection

    def initialize(token, secret)
      @connection = OAuth::AccessToken.new(Etsy::Authorization.consumer, token, secret)
    end

    # provides direct access to the OAuth Access Token
    def connection
      @connection
    end
  end
end
