module Broadbean
  class Payload

    def initialize(payload)
      @xml_doc = extract_xml_from(payload)
      @items = []
    end

    def standard_data
      data = { id: nil, time: nil }

      id   = xml_doc.at_xpath('//AdCourierAPIResponse/ResponseId')
      time = xml_doc.at_xpath('//AdCourierAPIResponse/TimeNow')

      data[:id] = id.text if id
      data[:time] = to_rails_time(time.text) if time

      data
    end

    def method_data(method_name)
      payload_items = xml_doc.xpath("//AdCourierAPIResponse/#{method_name}Response")
      payload_items.each { |item| extract_from_payload(item) }
      items
    end

    def failure_message
      msg = xml_doc.at_xpath('//AdCourierAPIResponse/Failed/Message')
      msg ? msg.text : nil
    end

  private

    attr_reader :xml_doc, :items

    def extract_xml_from(payload)
      Nokogiri::XML(payload)
    end

    def to_rails_time(broadbean_time)
      Time.strptime(broadbean_time, RESPONSE_TIME_FORMAT).in_time_zone(Time.zone)
    end

    def extract_from_payload(xml_doc_node)
      @items << parse(xml_doc_node)
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

    def not_comment(node)
      node.name != 'comment'
    end
  end
end