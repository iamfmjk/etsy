module Etsy

  # = User
  #
  # Represents a single Etsy user - has the following attributes:
  #
  # [id] The unique identifier for this user
  # [username] This user's username
  # [email] This user's email address (authenticated calls only)
  #
  class User

    include Etsy::Model

    attribute :id, :from => :user_id
    attribute :username, :from => :login_name
    attribute :email, :from => :primary_email
    attribute :created, :from => :creation_tsz

    # Retrieve one or more users by name or ID:
    #
    #   Etsy::User.find('reagent')
    #
    # You can find multiple users by passing an array of identifiers:
    #
    #   Etsy::User.find(['reagent', 'littletjane'])
    #
    def self.find(*identifiers_and_options)
      return self.find_one_or_more('users', identifiers_and_options)
    end

    # Retrieve the currently authenticated user.
    #
    def self.myself(token, secret)
      self.find('__SELF__', :access_token => token, :access_secret => secret)
    end

    # The shop associated with this user.
    #
    def shop
      @shop ||= Shop.find(username)
    end

    # Time that this user was created
    #
    def created_at
      Time.at(created)
    end

  end
end
