module Etsy

  class OAuthTokenRevoked < StandardError; end
  class MissingShopID < StandardError; end
  class EtsyJSONInvalid < StandardError; end
  class TemporaryIssue < StandardError; end
  class InvalidUserID < StandardError; end

  # = Response
  #
  # Basic wrapper around the Etsy JSON response data
  #
  class Response

    # Create a new response based on the raw HTTP response
    def initialize(raw_response)
      @raw_response = raw_response
    end

    # Convert the raw JSON data to a hash
    def to_hash
      validate!
      @hash ||= json
    end

    def body
      @raw_response.body
    end

    def code
      @raw_response.code
    end

    # Number of records in the response results
    def count
      if paginated?
        to_hash['results'].nil? ? 0 : to_hash['results'].size
      else
        to_hash['count']
      end
    end

    # Results of the API request
    def result
      if success?
        results = to_hash['results'] || []
        count == 1 ? results.first : results
      else
        []
      end
    end

    def success?
      !!(code =~ /2\d\d/)
    end

    def paginated?
      !!to_hash['pagination']
    end

    private

    def data
      @raw_response.body
    end

    def json
      @hash ||= JSON.parse(data)
    end

    def validate!
      raise OAuthTokenRevoked         if token_revoked?
      raise MissingShopID             if missing_shop_id?
      raise InvalidUserID             if invalid_user_id?
      raise TemporaryIssue            if temporary_etsy_issue? || resource_unavailable? || exceeded_rate_limit?
      raise EtsyJSONInvalid.new(data) unless valid_json?
      true
    end

    def valid_json?
      json
      return true
    rescue JSON::ParserError
      return false
    end

    def token_revoked?
      data == "oauth_problem=token_revoked"
    end

    def missing_shop_id?
      data =~ /Shop with PK shop_id/
    end

    def invalid_user_id?
      data =~ /is not a valid user_id/
    end

    def temporary_etsy_issue?
      data =~ /Temporary Etsy issue/
    end

    def resource_unavailable?
      data =~ /Resource temporarily unavailable/
    end

    def exceeded_rate_limit?
      data =~ /You have exceeded/
    end

  end
end
