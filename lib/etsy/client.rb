module Etsy
  class Client
    attr_accessor :oauth_token, :oauth_secret

    def initialize(options={})
      @api_key      = options[:api_key]
      @api_secret   = options[:api_secret]
      @oauth_token  = options[:oauth_token]
      @oauth_secret = options[:oauth_secret]
      @environment = options[:environment] || :production
    end

    def myself
      get("users/__SELF__").body["results"].first
    end

    def user(username)
      get("users", :keywords => username).body["results"].first
    end

    def request_token
      consumer = OAuth::Consumer.new(@api_key, @api_secret,
        :site               => endpoint,
        :request_token_path => "/v2/oauth/request_token",
        :access_token_path  => "/v2/oauth/access_token"
      )
      consumer.get_request_token
    end

    def oauth_token(req, verifier)
      access_token = req.get_access_token :oauth_verifier => verifier
      [access_token.token, access_token.secret]
    end

    def get(path, options={})
      connection.get(path, options)
    end

    private

    def connection
      @connection ||= Faraday.new(
        :url => "#{endpoint}/v2",
        :params => default_params
      ) do |conn|
        conn.request :json
        conn.request :oauth, {
          :token           => @oauth_token,
          :token_secret    => @oauth_secret,
          :consumer_key    => @api_key,
          :consumer_secret => @api_secret
        } if @oauth_token

        conn.response :json, :content_type => /\bjson$/

        conn.adapter Faraday.default_adapter
      end
    end

    def endpoint
      @environment == :production ? "http://openapi.etsy.com" : "http://sandbox.openapi.etsy.com"
    end

    def default_params
      params = {}
      params[:api_key] = @api_key if @api_key && !@oauth_token

      params
    end
  end
end
