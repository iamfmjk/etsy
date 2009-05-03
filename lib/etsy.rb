$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'json'

require 'etsy/request'
require 'etsy/response'

require 'etsy/model'
require 'etsy/user'
require 'etsy/shop'
require 'etsy/listing'
require 'etsy/image'

# = Etsy
#
module Etsy
 
  # Set the API key for all requests
  def self.api_key=(api_key)
    @api_key = api_key
  end
  
  # Retrieve the API key
  def self.api_key
    @api_key
  end
  
  # Find a user by username
  def self.user(username)
    User.find_by_username(username)
  end
  
end