module Etsy
  class Transaction
    include Model

    attribute :id, :from => :transaction_id
    attribute :buyer_id, :from => :buyer_user_id
    attribute :seller_id, :from => :seller_user_id
    attributes :quantity, :listing_id

    attribute :created, :from => :creation_tsz
    attribute :shipped, :from => :shipped_tsz
    attribute :paid, :from => :paid_tsz

    attributes :title, :description, :price, :currency_code, :quantity,
               :tags, :materials, :image_listing_id, :receipt_id,
               :is_digital, :file_data, :listing_id, :url, :product_data,
               :variations, :transaction_type, :buyer_feedback_id,
               :seller_feedback_id, :shipping_cost


    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/transactions", options)
    end

    def created_at
      Time.at(created)
    end

    def shipped_at
      Time.at(shipped)
    end

    def paid_at
      Time.at(paid)
    end

    def self.find(*identifiers_and_options)
      find_one_or_more('transactions', identifiers_and_options)
    end

    #Find all Transactions by the buyer_id
    #
    def self.find_all_by_buyer_id(user_id, options = {})
      get_all("/users/#{user_id}/transactions", options)
    end

    def self.find_all_by_listing_id(listing_id, options = {})
      get_all("/listings/#{listing_id}/transactions", options)
    end

    def self.find_all_by_receipt_id(receipt_id, options = {})
      get_all("/receipts/#{receipt_id}/transactions", options)
    end

    def receipt
      @receipt ||= Receipt.find(receipt_id, oauth)
    end

    def buyer
      @buyer ||= User.find(buyer_id, oauth)
    end

    def listing
      @listing ||= Listing.find(listing_id, oauth)
    end

    private

    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end

  end
end