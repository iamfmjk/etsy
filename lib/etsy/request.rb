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

    # Create a new request for the resource with optional parameters
    def initialize(resource_path, parameters = {})
      parameters = parameters.dup
      @token = parameters.delete(:access_token) || Etsy.credentials[:access_token]
      @secret = parameters.delete(:access_secret) || Etsy.credentials[:access_secret]
      raise("Secure connection required. Please provide your OAuth credentials via :access_token and :access_secret in the parameters") if parameters.delete(:require_secure) && !secure?
      @resource_path = resource_path
      @resources = parameters.delete(:includes)
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
      @parameters = parameters
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
      client.post(endpoint_url)
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
      to_url(parameters.merge(:includes => resources.to_a.map { |r| association(r) }))
    end

    def to_url(val)
      if val.is_a? Array
        to_url(val.join(','))
      elsif val.is_a? Hash
        val.reject { |k, v|
          k.nil? || v.nil? || (k.respond_to?(:empty?) && k.empty?) || (v.respond_to?(:empty?) && v.empty?)
        }.map { |k, v| "#{to_url(k.to_s)}=#{to_url(v)}" }.join('&')
      else
        URI.escape(val.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
    end

    def association(options={}) # :nodoc:
      s = options[:resource].dup

      if options.include? :fields
        s << "(#{[options[:fields]].flatten.join(',')})"
      end

      if options.include?(:limit) || options.include?(:offset)
        s << ":#{options.fetch(:limit, 25)}:#{options.fetch(:offset, 0)}"
      end

      s
    end

    def endpoint_url # :nodoc:
      "#{base_path}#{@resource_path}?#{query}"
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
