module Broadbean
  class Response

    attr_reader :id, :time

    def initialize(method_name, http_response)
      @id = @time = @failure_message = nil
      @payload = []
      @http_response = http_response

      http_response_ok? ? extract_payload_for(method_name) : create_failure_message
    end

    def failure?
      !failure_message.nil?
    end

    def payload
      return failure_message if failure?
      @payload
    end

  private

    attr_reader :http_response, :failure_message

    def http_response_ok?
      http_response.class == Net::HTTPOK
    end

    def create_failure_message
      error   = humanize_error(http_response.class.name)
      code    = http_response.code
      message = http_response.msg

      @failure_message = "#{error}: #{code} #{message}"
    end

    def humanize_error(e)
      e.demodulize.underscore.titleize # 'Net::HTTPServerError' -> 'HTTP Server Error'
    end

    def extract_payload_for(method_name)
      p = Payload.new(http_response.body)

      standard_data = p.standard_data
      failure_reported = p.failure_message

      @id   = standard_data[:id]
      @time = standard_data[:time]

      if failure_reported
        @failure_message = failure_reported
      else
        @payload = p.method_data(method_name)
      end
    end
  end
end