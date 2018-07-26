module Etsy

  # = BillCharge
  #
  # Represents a charge to an Etsy member's account.
  #
  #
  class BillCharge

    include Etsy::Model

    attribute :id, :from => :bill_charge_id
    attribute :created, :from => :creation_tsz
    attribute :last_modified, :from => :last_modified_tsz

    attributes :type, :type_id, :user_id, :amount, :currency_code, :creation_month,
               :creation_year

    def self.find_all_by_user_id(user_id, options = {})
      get_all("/users/#{user_id}/charges", options)
    end

    def created_at
      Time.at(created)
    end

    def last_modified_at
      Time.at(last_modified)
    end
  end
end
