module Etsy
  class Client
    def initialize(options={})
      @api_key = options[:api_key]
    end

    def user(username)
      get("users", :keywords => username).body["results"].first
    end

    def get(path, options={})
      connection.get(path, options)
    end

    private

    def connection
      @connection ||= Faraday.new(
        :url => "http://openapi.etsy.com/v2",
        :params => default_params
      ) do |conn|
        conn.request :json
        conn.response :json, :content_type => /\bjson$/

        conn.adapter Faraday.default_adapter
      end
    end

    def default_params
      params = {}
      params[:api_key] = @api_key if @api_key

      params
    end
  end
end
