require 'json'
require 'nokogiri'
require 'active_support/core_ext/string'

module Broadbean
  class Command

    def initialize(command_xml)
      @command  = command_xml
      @request  = Broadbean::Request.new(@command)
      @response = nil
    end

    def execute
      http_response = request.send_out
      @response = Broadbean::Response.new(http_response)
    end

    def failed?
      return response.failure? if executed?
      false
    end

    def result
      return response.payload if executed?
      nil
    end

  private

    attr_reader :request, :response

    def executed?
      !response.nil?
    end

    def to_hash(json_string)
      JSON.parse(json_string, symbolize_names: true)
    end

    def add_single_xml_elements(xml, tags, values)
      tags.each { |tag| create_single_xml_element(xml, tag, values) }
    end

    def create_single_xml_element(xml, tag, values)
      element = tag.camelize
      value   = values[tag.to_sym]

      xml.send(element, value) if value
    end

    def add_multiple_xml_elements(xml, tags, element_sets)
      if tags
        tags.each { |tag| create_multiple_xml_element(xml, tag, element_sets) }
      end
    end

    def create_multiple_xml_element(xml, tag, element_sets)
      element_tag = tag.singularize.camelize
      elements = element_sets[tag.to_sym]

      if elements
        elements.each { |e| xml.send(element_tag, e[:value], name: e[:name]) }
      end
    end

    def account_tags
      %w{
        user_name
        password
      }
    end
  end
end