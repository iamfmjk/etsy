$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'json'
require 'oauth'
require 'uri'

require 'etsy/request'
require 'etsy/response'

require 'etsy/basic_client'
require 'etsy/secure_client'
require 'etsy/verification_request'

require 'etsy/model'
require 'etsy/user'
require 'etsy/profile'
require 'etsy/shop'
require 'etsy/listing'
require 'etsy/attribute_value'
require 'etsy/image'
require 'etsy/transaction'
require 'etsy/address'
require 'etsy/category'
require 'etsy/payment_template'
require 'etsy/country'
require 'etsy/shipping_template'
require 'etsy/shipping_info'
require 'etsy/section'
require 'etsy/favorite_listing'
require 'etsy/receipt'
require 'etsy/variation/property_set'
require 'etsy/about'

# = Etsy: A friendly Ruby interface to the Etsy API
#
# == Quick Start
#
# Getting started is easy. First, you will need a valid API key from the Etsy
# developer site (http://developer.etsy.com/).
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
#     user.shop
#     user.shop.title
#
#     # ... and the listings in the shop
#     listing = user.shop.listings.first
#     listing.title
#     listing.description
#
# To see what else is available for a user, check out the full documentation for
# the Etsy::User class. Information about making authenticated calls is available
# in the README.
#
module Etsy
  class Error < RuntimeError; end

  class << self
    attr_writer :callback_url
    attr_writer :permission_scopes
  end

  # Make Etsy.api_key and Etsy.api_secret global but also local to threads
  #
  def self.api_key
    Thread.current[:etsy_api_key] || @api_key
  end

  def self.api_key=(key)
    @api_key ||= key
    Thread.current[:etsy_api_key] = key
  end

  def self.api_secret
    Thread.current[:etsy_api_secret] || @api_secret
  end

  def self.api_secret=(secret)
    @api_secret ||= secret
    Thread.current[:etsy_api_secret] = secret
  end

  SANDBOX_HOST = 'sandbox.openapi.etsy.com'
  PRODUCTION_HOST = 'openapi.etsy.com'

  # Set the environment, accepts either :sandbox or :production. Defaults to :sandbox
  # and will raise an exception when set to an unrecognized environment.
  #
  def self.environment=(environment)
    unless [:sandbox, :production].include?(environment)
      raise(ArgumentError, "environment must be set to either :sandbox or :production")
    end
    @environment = environment
    @host = (environment == :sandbox) ? SANDBOX_HOST : PRODUCTION_HOST
  end

  def self.protocol=(protocol)
    unless ["http", "https"].include?(protocol.to_s)
      raise(ArgumentError, "protocol must be set to either 'http' or 'https'")
    end
    @protocol = protocol.to_s
  end

  # Allow throwing API errors
  #
  def self.silent_errors=(bool)
    unless [TrueClass, FalseClass].include?(bool.class)
      raise(ArgumentError, "Silent errors must be set to either true or false'")
    end
    @silent_errors = bool
  end

  def self.protocol
    @protocol || "https"
  end

  # The currently configured environment.
  #
  def self.environment
    @environment || :production
  end

  # The default will change to false for a 1.0 release (breaking changes)
  #
  def self.silent_errors
    @silent_errors.nil? ? true : @silent_errors
  end

  def self.host # :nodoc:
    @host || PRODUCTION_HOST
  end

  # The configured callback URL or 'oob' if no callback URL is configured. This controls
  # whether or not we need to pass the OAuth verifier by hand.
  #
  def self.callback_url
    @callback_url || 'oob'
  end

  # OAuth permission scopes. Defines which private fields we can have access to.
  #
  def self.permission_scopes
    @permission_scopes || []
  end

  # Find a user by username.  See Etsy::User for more information.
  #
  def self.user(username)
    User.find(username)
  end

  # Convenience method for accessing the authenticated user's own user information. Requires
  # authentication.
  #
  def self.myself(token, secret, options = {})
    User.myself(token, secret, options)
  end

  # Generate a request token for authorization.
  #
  def self.request_token
    clear_for_new_authorization
    verification_request.request_token
  end

  # Generate an access token from the request token, secret, and verifier. The verifier can
  # either be passed manually or from the params in the callback URL.
  #
  def self.access_token(request_token, request_secret, verifier)
    @access_token = begin
      client = Etsy::SecureClient.new({
        :request_token  => request_token,
        :request_secret => request_secret,
        :verifier       => verifier
      })
      client.client
    end
  end

  # Generate the URL to begin the verification process for a user.
  #
  def self.verification_url
    verification_request.url
  end

  def self.single_user(access_token, access_secret)
    @credentials = {
      :access_token => access_token,
      :access_secret => access_secret
    }
    nil
  end

  def self.credentials
    @credentials || {}
  end

  private

  def self.verification_request
    @verification_request ||= VerificationRequest.new
  end

  def self.clear_for_new_authorization
    @verification_request = nil
  end

  def self.deprecate(message)
    puts "DEPRECATED: #{message}."
  end
end
