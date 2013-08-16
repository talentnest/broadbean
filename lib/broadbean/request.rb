require 'net/https'

module Broadbean
  class Request
    def initialize(message)
      @message = message
    end

    def send_out
      perform_http_request
    end

  private

    attr_reader :message

    def perform_http_request
      Net::HTTP.start(URL.host, URL.port, use_ssl: true) { |http| http.request new_http_request }
    end

    def new_http_request
      request = Net::HTTP::Post.new(URL.path)
      request.content_type = CONTENT_TYPE
      request.body = message
      request
    end
  end
end