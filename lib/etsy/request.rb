module Etsy

  # = Request
  #
  # A basic wrapper around GET requests to the Etsy JSON API
  #
  class Request

    def self.host # :nodoc:
      'openapi.etsy.com'
    end

    # Perform a GET request for the resource with optional parameters - returns
    # A Response object with the payload data
    def self.get(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.get)
    end

    # Create a new request for the resource with optional parameters
    def initialize(resource_path, parameters = {})
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
      @parameters    = parameters
    end

    def base_path # :nodoc:
      parts = ['v2']
      parts << 'sandbox' if Etsy.environment == :sandbox
      parts << (secure? ? 'private' : 'public')

      "/#{parts.join('/')}"
    end

    # Perform a GET request against the API endpoint and return the raw
    # response data
    def get
      client.get(endpoint_url)
    end

    def client # :nodoc:
      @client ||= secure? ? secure_client : basic_client
    end

    def parameters # :nodoc:
      @parameters.merge(:api_key => Etsy.api_key, :detail_level => 'high')
    end

    def resources # :nodoc:
      @resources
    end

    def query # :nodoc:
      q = parameters.map {|k,v| "#{k}=#{v}"}.join('&')
      q << "&includes=#{resources.map {|r| association(r)}.join(',')}" if resources
      q
    end

    def association(options={}) # :nodoc:
      s = options[:resource].capitalize
      s << "(#{options[:fields].join(',')})" if options[:fields]
      if options[:limit] || options[:offset]
        options[:limit] ||= 25
        options[:offset] ||= 0
        s << ":#{options[:limit]}:#{options[:offset]}"
      end
      s
    end

    def endpoint_url # :nodoc:
      "#{base_path}#{@resource_path}?#{query}"
    end

    private

    def secure_client
      SecureClient.new(:access_token => @parameters[:access_token], :access_secret => @parameters[:access_secret])
    end

    def basic_client
      BasicClient.new(self.class.host)
    end

    def secure?
      Etsy.access_mode == :read_write && !@parameters[:access_token].nil? && !@parameters[:access_secret].nil?
    end

  end
end
