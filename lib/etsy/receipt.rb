module Etsy
  class Receipt
    include Model

    attribute :id, :from => :receipt_id
    attribute :buyer_id, :from => :buyer_user_id

    attribute :created, :from => :creation_tsz
    attribute :last_modified, :from => :last_modified_tsz

    attributes :quantity, :listing_id, :name, :first_line, :second_line, :city, :state, :zip, :country_id,
               :payment_email, :buyer_email

    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/receipts", options)
    end

    def self.find_all_by_shop_id_and_status(shop_id, status, options = {})
      get_all("/shops/#{shop_id}/receipts/#{status}", options)
    end

    def created_at
      Time.at(created)
    end

    def buyer
      @buyer ||= User.find(buyer_id)
    end

    def transactions
      unless @transactions
        options = {}
        options = options.merge(:access_token => token, :access_secret => secret) if (token && secret)
        @transactions = Transaction.find_all_by_receipt_id(id, options)
      end
      @transactions
    end

  end
end
