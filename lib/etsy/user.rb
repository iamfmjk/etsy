module Etsy
  
  # = User
  #
  # Represents a single Etsy user
  #
  class User
    
    def self.attribute(name, options = {})
      
      from = options.fetch(:from, name)
      
      class_eval <<-CODE
        def #{name}
          @result['#{from}']
        end
      CODE
    end
    
    # Find a user by username
    def self.find_by_username(username)
      response = Request.get("/users/#{username}")
      User.new(response.result)
    end
    
    attribute :username, :from => :user_name
    attribute :id, :from => :user_id
    attribute :url
    
    def initialize(result) # :nodoc:
      @result = result
    end
    
  end
end