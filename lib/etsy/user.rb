module Etsy
  
  # = User
  #
  # Represents a single Etsy user
  #
  class User
    
    include Etsy::Model
    
    finder :one, '/users/:username'
    
    attribute :username, :from => :user_name
    attribute :id, :from => :user_id
    attribute :joined, :from => :join_epoch
    attribute :seller, :from => :is_seller
    attribute :last_login, :from => :last_login_epoch

    attributes :url, :city, :gender, :bio
    
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