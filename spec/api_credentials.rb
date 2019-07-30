module Etsy
  module Test
    API_KEY        = ENV["ETSY_API_KEY"]        || "API_KEY"
    API_SECRET     = ENV["ETSY_API_SECRET"]     || "API_SECRET"
    OAUTH_TOKEN    = ENV["ETSY_OAUTH_TOKEN"]    || "OAUTH_TOKEN"
    OAUTH_SECRET   = ENV["ETSY_OAUTH_SECRET"]   || "OAUTH_SECRET"
    OAUTH_VERIFIER = ENV["ETSY_OAUTH_VERIFIER"] || "OAUTH_VERIFIER"
    ENVIRONMENT    = ENV["ETSY_ENVIRONMENT"] || 'production'
  end
end
