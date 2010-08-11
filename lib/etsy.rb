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

# = Etsy: A friendly Ruby interface to the Etsy API
#
# == Quick Start
#
# Getting started is easy.  First, you will need a valid API key from the Etsy
# developer site (http://developer.etsy.com/).  Since the API is read-only at
# the moment, that's all you need to do.
#
# To start using the API, require the etsy gem and set it up to use your API key:
#
#     require 'rubygems'
#     require 'etsy'
#
#     Etsy.api_key = 'itsasecret'
#
# Now you can make API calls that originate from an Etsy user:
#
#     # Find a user by username
#     user = Etsy.user('littletjane')
#
#     # Grab that user's shop information
#     user.seller?
#     user.shop
#     user.shop.title
#
#     # ... and the listings in the shop
#     listing = user.shop.listings.first
#     listing.title
#     listing.description
#
# To see what else is available for a user, check out the full documentation for
# the Etsy::User class.
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

  def self.environment=(environment)
    unless [:sandbox, :production].include?(environment)
      raise(ArgumentError, "environment must be set to either :sandbox or :production")
    end
    @environment = environment
  end

  def self.environment
    @environment || :sandbox
  end

  # Find a user by username.  See Etsy::User for more information.
  def self.user(username)
    User.find_by_username(username)
  end

end