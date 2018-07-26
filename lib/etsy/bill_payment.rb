module Etsy

  # = BillPayment
  #
  # Represents a user's Billing Payment.
  #
  #
  class BillPayment

    include Etsy::Model

    attribute :id, :from => :bill_payment_id
    attribute :created, :from => :creation_tsz

    attributes :type, :type_id, :user_id, :amount, :currency_code, :creation_month,
               :creation_year

    def self.find_all_by_user_id(user_id, options = {})
      get_all("/users/#{user_id}/payments", options)
    end

    # Time that this listing was created
    #
    def created_at
      Time.at(created)
    end
  end
end
