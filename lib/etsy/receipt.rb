module Etsy
  class Receipt
    include Model

    attribute :id, :from => :receipt_id
    attribute :buyer_id, :from => :buyer_user_id

    attributes :quantity, :listing_id, :name, :first_line, :second_line, :city, :state, :zip, :country_id,
               :payment_email, :buyer_email, :creation_tsz

    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/receipts", options)
    end

    def created_at
      Time.at(creation_tsz)
    end

    def buyer
      @buyer ||= User.find(buyer_id)
    end

  end
end
