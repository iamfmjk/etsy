module Etsy
  
  # = Response
  # 
  # Basic wrapper around the Etsy JSON response data
  #
  class Response
    
    # Create a new response based on the raw JSON
    def initialize(data)
      @data = data
    end
    
    # Convert the raw JSON data to a hash
    def to_hash
      @hash ||= JSON.parse(@data)
    end
    
    # Number of records in the response results
    def count
      to_hash['count']
    end
    
    # Results of the API request
    def result
      to_hash['results']
    end
    
  end
end