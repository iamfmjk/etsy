module Etsy

  # = Request
  #
  # A basic wrapper around GET requests to the Etsy JSON API
  #
  class Request

    # Perform a GET request for the resource with optional parameters - returns
    # A Response object with the payload data
    def self.get(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.get)
    end

    def self.post(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.post)
    end

    def self.put(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.put)
    end

    # Create a new request for the resource with optional parameters
    def initialize(resource_path, parameters = {})
      @token = parameters.delete(:access_token) || Etsy.credentials[:access_token]
      @secret = parameters.delete(:access_secret) || Etsy.credentials[:access_secret]
      raise("Secure connection required. Please provide your OAuth credentials via :access_token and :access_secret in the parameters") if parameters.delete(:require_secure) && !secure?
      @multipart_request = parameters.delete(:multipart)
      @resource_path = resource_path
      @resources     = parameters.delete(:includes)
      if @resources.class == String
        @resources = @resources.split(',').map {|r| {:resource => r}}
      elsif @resources.class == Array
        @resources = @resources.map do |r|
          if r.class == String
            {:resource => r}
          else
            r
          end
        end
      end
      parameters = parameters.merge(:api_key => Etsy.api_key) unless secure?
      @parameters    = parameters
      @parameters[:fields] = fields_from(@parameters[:fields]) if @parameters[:fields]
    end

    def base_path # :nodoc:
      "/v2"
    end

    # Perform a GET request against the API endpoint and return the raw
    # response data
    def get
      client.get(endpoint_url)
    end

    def post
      if multipart?
        client.post_multipart(endpoint_url(:include_query => false), @parameters)
      else
        client.post(endpoint_url)
      end
    end

    def put
      client.put(endpoint_url)
    end

    def client # :nodoc:
      @client ||= secure? ? secure_client : basic_client
    end

    def parameters # :nodoc:
      @parameters
    end

    def resources # :nodoc:
      @resources
    end

    def query # :nodoc:
      q = parameters.map {|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.join('&')
      q << "&includes=#{URI.escape(resources.map {|r| association(r)}.join(','))}" if resources
      q
    end

    def association(options={}) # :nodoc:
      s = options[:resource].capitalize
      s << "(#{fields_from(options[:fields])})" if options[:fields]
      if options[:limit] || options[:offset]
        options[:limit] ||= 25
        options[:offset] ||= 0
        s << ":#{options[:limit]}:#{options[:offset]}"
      end
      s
    end

    def fields_from(fields)
      fields.is_a?(Array) ? fields.join(',') : fields
    end

    def endpoint_url(options = {}) # :nodoc:
      url = "#{base_path}#{@resource_path}"
      url += "?#{query}" if options.fetch(:include_query, true)
      url
    end

    def multipart?
      !!@multipart_request
    end

    private

    def secure_client
      SecureClient.new(:access_token => @token, :access_secret => @secret)
    end

    def basic_client
      BasicClient.new(Etsy.host)
    end

    def secure?
      !@token.nil? && !@secret.nil?
    end

  end
end
