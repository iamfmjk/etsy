module Etsy
  class PaymentTemplate
    include Etsy::Model

    attribute :id, :from => :payment_template_id
    attributes :allow_check, :allow_mo, :allow_other, :allow_paypal, :allow_cc
    attributes :paypal_email, :name, :first_line, :second_line, :city, :state
    attributes :zip, :country_id

    def self.create(options = {})
      options.merge!(:require_secure => true)
      post("/payments/templates", options)
    end
 
    def self.find(id, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/payments/templates/#{id}", options)
    end

    def self.find_by_user(user, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/users/#{user.id}/payments/templates", options)
    end
  end
end
