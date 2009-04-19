module Etsy
  
  # = User
  #
  # Represents a single Etsy user
  #
  class User
    
    # Find a user by username
    def self.find_by_username(username)
      response = Request.get("/users/#{username}")
      User.new(response.result)
    end
    
    def initialize(result) # :nodoc:
      @result = result
    end
    
    def username
      @result['user_name']
    end
    
    def id
      @result['user_id']
    end
    
    def url
      @result['url']
    end
    
  end
end