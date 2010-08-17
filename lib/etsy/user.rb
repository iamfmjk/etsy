module Etsy

  # = User
  #
  # Represents a single Etsy user - has the following attributes:
  #
  # [id] The unique identifier for this user
  # [username] This user's username
  #
  class User

    include Etsy::Model

    def self.find(*identifiers)
      response = Request.get("/users/#{identifiers.join(',')}")
      users = [response.result].flatten.map {|data| new(data) }

      (identifiers.length == 1) ? users[0] : users
    end

    def self.all(options = {})
      response = Request.get('/users', options)
      response.result.map {|data| new(data) }
    end

    attribute :id, :from => :user_id
    attribute :username, :from => :login_name
    attribute :created, :from => :creation_tsz

    # Time that this user was created
    #
    def created_at
      Time.at(created)
    end

  end
end