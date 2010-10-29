module Etsy
  class SecureClient

    def initialize(attributes = {})
      @attributes = attributes
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(Etsy.api_key, Etsy.api_secret, {
        :site               => 'http://openapi.etsy.com',
        :request_token_path => '/v2/sandbox/oauth/request_token',
        :access_token_path  => '/v2/sandbox/oauth/access_token',
        :authorize_url      => 'https://www.etsy.com/oauth/signin'
      })
    end

    def request_token
      consumer.get_request_token
    end

    def access_token
      @attributes[:access_token] || client.token
    end

    def access_secret
      @attributes[:access_secret] || client.secret
    end

    def client_from_request_data
      request_token = OAuth::RequestToken.new(consumer, @attributes[:request_token], @attributes[:request_secret])
      request_token.get_access_token(:oauth_verifier => @attributes[:verifier])
    end

    def client_from_access_data
      OAuth::AccessToken.new(consumer, @attributes[:access_token], @attributes[:access_secret])
    end

    def client
      @client ||= has_access_data? ? client_from_access_data : client_from_request_data
    end

    private

    def has_access_data?
      !@attributes[:access_token].nil? && !@attributes[:access_secret].nil?
    end

  end
end
