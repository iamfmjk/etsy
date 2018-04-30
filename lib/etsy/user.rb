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
    association :bill_charges, :from => 'BillCharges'
    association :bill_payments, :from => 'BillPayments'

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

    def bill_charges
      unless @bill_charges
        if associated_bill_charges
          @bill_charges = associated_bill_charges.map { |bill_charge| BillCharge.new(bill_charge) }
        else
          options = {:fields => 'user_id', :includes => 'BillCharges'}
          options = options.merge(:access_token => token, :access_secret => secret) if (token && secret)
          tmp = User.find(username, options)
          @bill_charges = tmp.associated_bill_charges.map { |bill_charge| BillCharge.new(bill_charge) }
        end
      end
      @bill_charges
    end

    def bill_payments
      unless @bill_payments
        if associated_bill_payments
          @bill_payments = associated_bill_payments.map { |bill_payment| BillPayment.new(bill_payment) }
        else
          options = {:fields => 'user_id', :includes => 'BillPayments'}
          options = options.merge(:access_token => token, :access_secret => secret) if (token && secret)
          tmp = User.find(username, options)
          @bill_payments = tmp.associated_bill_payments.map { |bill_payment| BillPayment.new(bill_payment) }
        end
      end
      @bill_payments
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

    #Return a set of listings that have been bought
    #
    def bought_listings
      unless @bought_listings
        @bought_listings = Listing.bought_listings(id, {:access_token => token, :access_secret => secret})
      end
      @bought_listings
    end

  end
end
