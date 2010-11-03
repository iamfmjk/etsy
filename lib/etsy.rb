$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'json'
require 'oauth'

require 'etsy/request'
require 'etsy/response'

require 'etsy/basic_client'
require 'etsy/secure_client'
require 'etsy/verification_request'

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

  class << self
    attr_accessor :api_key, :api_secret
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

  def self.callback_url=(url)
    @callback_url = url
  end

  def self.callback_url
    @callback_url || 'oob'
  end

  # Find a user by username.  See Etsy::User for more information.
  def self.user(username)
    User.find(username)
  end

  def self.request_token
    verification_request.request_token
  end

  def self.access_token(request_token, request_secret, verifier)
    @access_token ||= begin
      client = Etsy::SecureClient.new({
        :request_token  => request_token,
        :request_secret => request_secret,
        :verifier       => verifier
      })
      client.client
    end
  end

  def self.verification_url
    verification_request.url
  end

  private

  def self.verification_request
    @verification_request ||= VerificationRequest.new
  end
end
