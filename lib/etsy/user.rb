module Etsy
  
  # = User
  #
  # Represents a single Etsy user
  #
  class User
    
    include Etsy::Model
    
    # Find a user by username
    def self.find_by_username(username)
      response = Request.get("/users/#{username}")
      User.new(response.result)
    end
    
    attribute :username, :from => :user_name
    attribute :id, :from => :user_id
    attribute :url
    
    def shop
      Shop.find_by_user_id(id)
    end
    
  end
end