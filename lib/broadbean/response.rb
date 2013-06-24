module Broadbean
  class Response

    attr_reader :id, :time

    def initialize(http_response)
      @http_response   = http_response
      @xml_message     = nil
      @payload         = nil
      @failure_message = nil
      @id              = nil
      @time            = nil

      check_if_http_error

      unless failure?
        extract_xml_message
        extract_payload
      end
    end

    def failure?
      !failure_message.nil?
    end

    def payload
      return failure_message if failure?
      @payload
    end

  private

    attr_reader :http_response, :failure_message, :xml_message

    def check_if_http_error
      create_failure_message unless http_response.class == Net::HTTPSuccess
    end

    def create_failure_message
      error    = http_response.class.name.demodulize
      code     = http_response.code
      message  = http_response.msg

      @failure_message = "#{error}: #{code} #{message}"
    end

    def extract_xml_message
      @xml_message = Nokogiri::XML(http_response.body)
    end

    def extract_payload
      if xml_message
        extract_consistent_elements
        check_if_command_failed
        parse_payload unless failure?
      end
    end

    def parse_payload
      # XML => ruby structure... ?
    end

    def extract_consistent_elements
      id   = xml_message.xpath("//AdCourierAPIResponse/ResponseId").first
      time = xml_message.xpath("//AdCourierAPIResponse/TimeNow").first

      @id   = id.text   if id
      @time = time.text if time
    end

    def check_if_command_failed
      failed_msg = xml_message.xpath("//AdCourierAPIResponse/Failed/Message").first
      @failure_message = failed_msg.text if failed_msg
    end
  end
end