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
      @result[0]['user_name']
    end
    
    def id
      @result[0]['user_id']
    end
    
    def url
      @result[0]['url']
    end
    
  end
end