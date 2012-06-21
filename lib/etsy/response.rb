module Etsy

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
      @hash ||= JSON.parse(data)
    end

    def body
      @raw_response.body
    end

    def code
      @raw_response.code
    end

    # Number of records in the response results
    def count
      to_hash['count']
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

    private

    def data
      @raw_response.body
    end

  end
end
