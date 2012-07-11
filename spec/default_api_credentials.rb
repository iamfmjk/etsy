custom_credentials = File.join(File.dirname(__FILE__), "api_credentials.rb")
if File.exists? custom_credentials
  require custom_credentials
else
  API_KEY = "API_KEY"
end
