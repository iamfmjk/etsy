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
      path = '/v2/oauth/'
      @consumer ||= OAuth::Consumer.new(Etsy.api_key, Etsy.api_secret, {
        :site               => "http://#{Etsy.host}",
        :request_token_path => "#{path}request_token?scope=#{Etsy.permission_scopes.join('+')}",
        :access_token_path  => "#{path}access_token"
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

    def post(endpoint)
      client.post(endpoint)
    end

    def put(endpoint)
      client.put(endpoint)
    end

    def post_multipart(endpoint, params = {})
      Net::HTTP.new(Etsy.host).start do |http|
        req = Net::HTTP::Post.new(endpoint)
        add_multipart_data(req, params)
        add_oauth(req)
        res = http.request(req)
      end
    end

    private

    # Encodes the request as multipart
    def add_multipart_data(req, params)
      crlf = "\r\n"
      boundary = Time.now.to_i.to_s(16)
      req["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
      body = ""
      params.each do |key,value|
        esc_key = CGI.escape(key.to_s)
        body << "--#{boundary}#{crlf}"
        if value.respond_to?(:read)
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{crlf}"
          body << "Content-Type: image/jpeg#{crlf*2}"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{crlf*2}#{value}"
        end
        body << crlf
      end
      body << "--#{boundary}--#{crlf*2}"
      req.body = body
      req["Content-Length"] = req.body.size
    end

    # Uses the OAuth gem to add the signed Authorization header
    def add_oauth(req)
      client.sign!(req)
    end

    def has_access_data?
      !@attributes[:access_token].nil? && !@attributes[:access_secret].nil?
    end

  end
end
