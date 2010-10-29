module Etsy
  class VerificationRequest

    def client
      @client ||= SecureClient.new
    end

    def url
      "#{request_token.authorize_url}&oauth_consumer_key=#{request_token.secret}"
    end

    private

    def request_token
      @request_token ||= client.request_token
    end

  end
end