module Etsy

  # = SecureClient
  #
  # Used for generating tokens and calling API methods that require authentication.
  #
  class SecureClient

    # Create a new client with the necessary parameters.  Accepts the following
    # key/value pairs:
    #
    #   :request_token
    #   :request_secret
    #   :access_token
    #   :access_secret
    #
    # The request token / secret is useful for generating the access token.  Pass
    # the access token / secret when initializing from stored credentials.
    #
    def initialize(attributes = {})
      @attributes = attributes
    end

    def consumer # :nodoc:
      @consumer ||= OAuth::Consumer.new(Etsy.api_key, Etsy.api_secret, {
        :site               => 'http://openapi.etsy.com',
        :request_token_path => '/v2/sandbox/oauth/request_token',
        :access_token_path  => '/v2/sandbox/oauth/access_token',
        :authorize_url      => 'https://www.etsy.com/oauth/signin'
      })
    end

    # Generate a request token.
    #
    def request_token
      consumer.get_request_token(:oauth_callback => Etsy.callback_url)
    end

    # Access token for this request, either generated from the request token or taken
    # from the :access_token parameter.
    #
    def access_token
      @attributes[:access_token] || client.token
    end

    # Access secret for this request, either generated from the request token or taken
    # from the :access_secret parameter.
    #
    def access_secret
      @attributes[:access_secret] || client.secret
    end

    def client_from_request_data # :nodoc:
      request_token = OAuth::RequestToken.new(consumer, @attributes[:request_token], @attributes[:request_secret])
      request_token.get_access_token(:oauth_verifier => @attributes[:verifier])
    end

    def client_from_access_data # :nodoc:
      OAuth::AccessToken.new(consumer, @attributes[:access_token], @attributes[:access_secret])
    end

    def client # :nodoc:
      @client ||= has_access_data? ? client_from_access_data : client_from_request_data
    end

    # Fetch a raw response from the specified endpoint.
    #
    def get(endpoint)
      client.get(endpoint)
    end

    private

    def has_access_data?
      !@attributes[:access_token].nil? && !@attributes[:access_secret].nil?
    end

  end
end
