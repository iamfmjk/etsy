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
    attribute :joined, :from => :join_epoch
    attribute :city
    attribute :gender
    attribute :seller, :from => :is_seller
    attribute :last_login, :from => :last_login_epoch
    attribute :bio
    
    def shop
      Shop.find_by_user_id(id)
    end
    
    def seller?
      seller
    end
    
    def joined_at
      Time.at(joined)
    end
    
    def last_login_at
      Time.at(last_login)
    end
    
  end
end