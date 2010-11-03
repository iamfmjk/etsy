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
      self.get("/users/#{identifiers.join(',')}")
    end

    def self.myself(token, secret)
      self.get("/users/__SELF__", :access_token => token, :access_secret => secret)
    end

    attribute :id, :from => :user_id
    attribute :username, :from => :login_name
    attribute :email, :from => :primary_email
    attribute :created, :from => :creation_tsz

    # Time that this user was created
    #
    def created_at
      Time.at(created)
    end

    private
    def self.get(query, options={})
      response = Request.get(query, options)
      users = [response.result].flatten.map {|data| new(data) }

      (users.length == 1) ? users[0] : users
    end
  end
end
