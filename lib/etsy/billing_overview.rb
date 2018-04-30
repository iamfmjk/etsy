module Etsy

  # = BillingOverview
  #
  # A user's account balance on Etsy.
  #
  class BillingOverview

    include Etsy::Model

    attributes :is_overdue, :overdue_balance, :balance_due, :total_balance, :currency_code, :date_due,
               :creation_year

    def self.find_all_by_user_id(user_id, options = {})
      get_all("/users/#{user_id}/billing/overview", options)
    end
  end
end
