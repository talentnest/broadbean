module Broadbean
  class Response

    attr_reader :id, :time

    def initialize(method_name, http_response)
      @id = nil
      @time = nil
      @payload = []

      @http_response = http_response
      @failure_message = nil

      if http_response_ok?
        extract_payload_for(method_name)
      else
        create_failure_message
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
      xml_doc = extract_xml

      if xml_doc
        get_standard_data_from(xml_doc)
        get_specific_data_for(method_name, xml_doc) unless failure_reported_in(xml_doc)
      end

    end

    def extract_xml
      Nokogiri::XML(http_response.body)
    end

    def get_standard_data_from(xml_doc)
      id   = xml_doc.at_xpath('//AdCourierAPIResponse/ResponseId')
      time = xml_doc.at_xpath('//AdCourierAPIResponse/TimeNow')

      @id = id.text if id
      @time = time.text if time
    end

    def get_specific_data_for(method_name, xml_doc)
      response_items = xml_doc.xpath("//AdCourierAPIResponse/#{method_name}Response")

      if response_items.count == 0
        @failure_message = "Broadbean responded but failed to provide data or a failure message for the action #{method_name}."
      else
        response_items.each { |xml_doc_node| add_to_payload(xml_doc_node) }
      end

    end

    def failure_reported_in(xml_doc)
      failed_msg = xml_doc.at_xpath('//AdCourierAPIResponse/Failed/Message')
      @failure_message = failed_msg.text if failed_msg
    end

    def add_to_payload(xml_doc_node)
      @payload << parse(xml_doc_node)
    end

    def parse(node)
      return base_recursive_case_for(node) unless node.element?

      result_hash = {}

      node_attributes = node.attributes
      node_children   = node.children.select{ |child| not_comment(child) }

      add_attributes_to(result_hash, node_attributes) unless node_attributes.empty?

      node_children.each do |child_node|
        child_node_result = parse(child_node)

        child_node_name = symbolize_tag(child_node.name)

        if child_node_name == :text

          unless has_siblings(child_node)
            if node_attributes.empty?
              return child_node_result
            else
              result_hash[:value] = child_node_result
              return result_hash
            end
          end

        elsif result_hash[child_node_name]

          if result_hash[child_node_name].is_a? Array
            result_hash[child_node_name] << child_node_result
          else
            result_hash[child_node_name] = [result_hash[child_node_name]] << child_node_result
          end

        else
          result_hash[child_node_name] = child_node_result
        end

      end

      result_hash
    end

    def not_comment(node)
      node.name != 'comment'
    end

    def base_recursive_case_for(xml_doc_node)
      xml_doc_node.content.to_s
    end

    def add_attributes_to(result_hash, node_attributes)
      node_attributes.each { |_, attr| add_to_hash(result_hash, attr) }
    end

    def symbolize_tag(tag)
      tag.underscore.to_sym
    end

    def has_siblings(child)
      child.next_sibling || child.previous_sibling
    end

    def add_to_hash(hash, attribute)
      attr_name = symbolize_tag(attribute.name)
      hash[attr_name] = attribute.value
    end
  end
end