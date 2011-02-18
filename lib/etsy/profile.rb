module Etsy

  # = Profile
  #
  # Represents a profile resource of an Etsy user.
  #
  class Profile

    include Etsy::Model

    attribute :id, :from => :user_profile_id
    attribute :user_id
    attribute :bio
    attribute :username, :from => :login_name
    attribute :gender
    attribute :birth_day
    attribute :birth_month
    attribute :birth_year
    attribute :joined, :from => :join_tsz
    attribute :favorite_materials, :from => :materials
    attribute :country_id
    attribute :city
    attribute :location
    attribute :region
    attribute :avatar_id
    attribute :image, :from => :image_url_75x75
    attribute :lat
    attribute :lon
    attribute :transaction_buy_count
    attribute :transaction_sold_count
    attribute :is_seller
    attribute :first_name
    attribute :last_name

    def materials
      favorite_materials ? favorite_materials.split(',') : []
    end

    # Time that this user joined Etsy
    #
    def joined_at
      Time.at(joined)
    end

    def seller?
      is_seller
    end
  end
end
