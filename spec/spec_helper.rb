require 'simplecov'
SimpleCov.start

require 'vcr'
require 'default_api_credentials'

require 'etsy'

require 'uri'
require 'cgi'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.register_request_matcher :parsed_query do |req_1, req_2|
    CGI.parse(URI(req_1.uri).query) == CGI.parse(URI(req_2.uri).query)
  end
  c.default_cassette_options = { :match_requests_on => [:method, :host, :path, :parsed_query] }
  c.hook_into :faraday
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.color_enabled  = true
  c.tty            = true
  c.formatter      = :documentation
  c.mock_framework = :mocha
end
