require 'simplecov'
SimpleCov.start

require 'vcr'
require 'default_api_credentials'

require 'etsy'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.color_enabled  = true
  c.tty            = true
  c.formatter      = :documentation
  c.mock_framework = :mocha
end
