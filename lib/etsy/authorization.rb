require 'oauth'

module Etsy
  # = OAuth
  #
  # A setup for the Etsy Read-Write API
  #
  class Authorization
    AUTHORIZE_URL = 'https://www.etsy.com/oauth/signin'

    def self.callback
      @callback || "oob"
    end

    def self.callback=(url)
      @callback = url
    end

    def self.request_token_path
      self.build_path("request")
    end

    def self.access_token_path
      self.build_path("access")
    end

    def self.build_path(type)
      path = '/v2'
      path << '/sandbox' if Etsy.environment == :sandbox
      path << "/oauth/#{type}_token"
      path
    end

    def self.consumer
      if Etsy.access_mode == :read_only
        raise(Error, "You have configured Etsy as read-only. No Authorization required.")
      end
      unless (Etsy.api_key && Etsy.api_secret)
        raise(ArgumentError, "Etsy API key and secret must be set")
      end
      options = {
        :site => Etsy::API_URL,
        :oauth_callback => Etsy::Authorization.callback,
        :request_token_path => Etsy::Authorization.request_token_path,
        :access_token_path => Etsy::Authorization.access_token_path,
        :authorize_url => Etsy::Authorization::AUTHORIZE_URL
      }
      OAuth::Consumer.new(Etsy.api_key, Etsy.api_secret, options) 
    end

  end
end
