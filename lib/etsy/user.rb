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

    association :profile, :from => 'Profile'
    association :shops, :from => 'Shops'

    # Retrieve one or more users by name or ID:
    #
    #   Etsy::User.find('reagent')
    #
    # You can find multiple users by passing an array of identifiers:
    #
    #   Etsy::User.find(['reagent', 'littletjane'])
    #
    def self.find(*identifiers_and_options)
      find_one_or_more('users', identifiers_and_options)
    end

    # Retrieve the currently authenticated user.
    #
    def self.myself(token, secret, options = {})
      find('__SELF__', {:access_token => token, :access_secret => secret}.merge(options))
    end

    # The shop associated with this user.
    #
    def shop
      @shop ||= shops.first
    end

    # The addresses associated with this user.
    #
    def addresses
      options = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
      @addresses ||= Address.find(username, options)
    end

    # The profile associated with this user.
    #
    def profile
      unless @profile
        if associated_profile
          @profile = Profile.new(associated_profile)
        else
          options = {:fields => 'user_id', :includes => 'Profile'}
          options = options.merge(:access_token => token, :access_secret => secret) if (token && secret)
          tmp = User.find(username, options)
          @profile = Profile.new(tmp.associated_profile)
        end
      end
      @profile
    end

    def shops
      unless @shops
        if associated_shops
          @shops = associated_shops.map { |shop| Shop.new(shop) }
        else
          options = {:fields => 'user_id', :includes => 'Shops'}
          options = options.merge(:access_token => token, :access_secret => secret) if (token && secret)
          tmp = User.find(username, options)
          @shops = tmp.associated_shops.map { |shop| Shop.new(shop) }
        end
      end
      @shops
    end

    # Time that this user was created
    #
    def created_at
      Time.at(created)
    end

    # Retrieve list of favorited items for this user
    #
    def favorites
      unless @favorites
        @favorites = Listing.find_all_user_favorite_listings(id, {:access_token => token, :access_secret => secret})
      end
      @favorites
    end

  end
end
