require 'net/https'

module Broadbean
  class Request
    def initialize(message)
      @message = message
    end

    def send_out
      http_response = http_request_transmission
    end

  private

    attr_reader :message

    def http_request_transmission
      Net::HTTP.start(Broadbean::URL.host, Broadbean::URL.port, use_ssl: true) { |http| http.request new_http_request }
    end

    def new_http_request
      request = Net::HTTP::Post.new(Broadbean::URL.path)
      request.content_type = Broadbean::CONTENT_TYPE
      request.body = message
      request
    end
  end
end