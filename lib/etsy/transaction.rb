module Etsy
  class Transaction
    include Model

    attribute :id, :from => :transaction_id
    attribute :buyer_id, :from => :buyer_user_id
    attributes :quantity, :listing_id

    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/transactions", options)
    end

    #Find all Transactions by the buyer_id
    #
    def self.find_all_by_buyer_id(user_id, options = {})
      get_all("/users/#{user_id}/transactions", options)
    end

    def buyer
      @buyer ||= User.find(buyer_id)
    end

  end
end