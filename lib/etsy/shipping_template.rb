module Etsy
  class ShippingTemplate
    include Etsy::Model

    attribute :id, :from => :shipping_template_id

    attributes :title, :user_id

    def self.create(options = {})
      options.merge!(:require_secure => true)
      post("/shipping/templates", options)
    end
 
    def self.find(id, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/shipping/templates/#{id}", options)
    end
    
    def self.find_entries(id, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/shipping/templates/#{id}/entries", options)
    end
    
    def self.find_by_user(user, credentials = {})
      options = {
        :access_token => credentials[:access_token],
        :access_secret => credentials[:access_secret],
        :require_secure => true
      }
      get("/users/#{user.id}/shipping/templates", options)
    end
  end
end
