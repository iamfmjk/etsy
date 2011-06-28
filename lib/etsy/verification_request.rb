module Etsy
  class VerificationRequest # :nodoc:all

    def client
      @client ||= SecureClient.new
    end

    def url
      request_token.params[:login_url]
    end

    def request_token
      @request_token ||= client.request_token
    end

  end
end
