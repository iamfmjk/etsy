module Etsy
  
  # = User
  #
  # Represents a single Etsy user - has the following attributes:
  #
  # [id] The unique identifier for this user
  # [username] This user's username
  # [url] The full URL to this user's profile page / shop (if seller)
  # [city] The user's city / state (optional)
  # [gender] The user's gender
  # [bio] User's biography
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
    
    # This user's shop, returns nil if user is not a seller. See Etsy::Shop
    # for more information.
    #
    def shop
      Shop.find_by_user_id(id) if seller?
    end
    
    # Is this user a seller?
    #
    def seller?
      seller
    end
    
    # Time that this user joined the site
    #
    def joined_at
      Time.at(joined)
    end
    
    # Time that this user last logged in
    #
    def last_login_at
      Time.at(last_login)
    end
    
  end
end