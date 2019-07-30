if ENV["TRAVIS"] != "true"
  require 'simplecov'
  SimpleCov.start
end

require 'vcr'
require 'api_credentials'

require 'etsy'

require 'uri'
require 'cgi'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.register_request_matcher :parsed_query do |req_1, req_2|
    req_1_query = URI(req_1.uri).query
    req_2_query = URI(req_2.uri).query

    if req_1_query.nil? == req_2_query.nil?
      true
    elsif req_1_query.nil? || req_2_query.nil?
      false
    else
      CGI.parse(req_1_query) == CGI.parse(req_2_query)
    end
  end
  c.default_cassette_options = { :match_requests_on => [:method, :host, :path, :parsed_query] }

  # Add sensitive fields here
  # Constants in Etsy::Test will be auto filtered
  Etsy::Test.constants.reverse.each do |const|
    c.filter_sensitive_data(const.to_s) { Etsy::Test.const_get(const) }
  end

  c.hook_into :faraday, :webmock
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.color_enabled  = true
  c.tty            = true
  c.formatter      = :documentation
  c.mock_framework = :mocha
end
