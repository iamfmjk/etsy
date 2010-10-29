$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'json'
require 'oauth'

require 'etsy/request'
require 'etsy/response'

require 'etsy/authorization'
require 'etsy/secure_connection'
require 'etsy/secure_client'

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
  class Error < RuntimeError; end

  API_URL = 'http://openapi.etsy.com'
  API_VERSION = '/v2'

  # Set the API key for all requests
  def self.api_key=(api_key)
    @api_key = api_key
  end

  # Retrieve the API key
  def self.api_key
    @api_key
  end

  # Set the API secret for write requests
  def self.api_secret=(api_secret)
    @api_secret = api_secret
  end

  # Retrieve the API secret
  def self.api_secret
    @api_secret
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

  def self.access_mode=(mode)
    unless [:read_only, :read_write].include?(mode)
      raise(ArgumentError, "access mode must be set to either :read_only or :read_write")
    end
    @access_mode = mode
  end

  def self.access_mode
    @access_mode || :read_only
  end

  # Find a user by username.  See Etsy::User for more information.
  def self.user(username)
    User.find(username)
  end

  # Begin Etsy OAuth process.  See Etsy::Authorization for more information.
  def self.request_token
    Etsy::Authorization.consumer.get_request_token
  end

  # Qualified URL to redirect user to in order to request access
  def self.verify_url(request_token)
    request_token.authorize_url + '&oauth_consumer_key=' + request_token.secret
  end

  # Get back the final access token and secret
  def self.access_token(token, secret, verifier)
    request_token = OAuth::RequestToken.new(Etsy::Authorization.consumer, token, secret)
    request_token.get_access_token(:oauth_verifier => verifier)
  end

  # Wrapper for secure communications using the access token
  def self.secure_connection(token, secret)
    Etsy::SecureConnection.new(token, secret)
  end
end

