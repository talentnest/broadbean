require 'json'
require 'nokogiri'

module Broadbean
  autoload :ExportCommand,          'broadbean/commands/export_command'
  autoload :AdvertCheckCommand,     'broadbean/commands/advert_check_command'
  autoload :StatusCheckCommand,     'broadbean/commands/status_check_command'
  autoload :DeleteCommand,          'broadbean/commands/delete_command'
  autoload :EnumeratedTypesCommand, 'broadbean/commands/enumerated_types_command'
  autoload :ListChannelsCommand,    'broadbean/commands/list_channels_command'

  class Command
    def initialize(command_specific_xml=nil)
      @command_builder = merge_common_xml_with(command_specific_xml)
      @request  = nil
      @response = nil
    end

    def authenticate(api_key, username, password)
      doc = command_builder.doc
      doc.at_css('APIKey').content   = api_key
      doc.at_css('UserName').content = username
      doc.at_css('Password').content = password
    end

    def execute
      @request  = Request.new(command_builder.to_xml)
      @response = Response.new(method_name, request.send_out)
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

    attr_reader :command_builder, :request, :response

    def executed?
      !response.nil?
    end

    def method_name
      self.class.name.demodulize.gsub(/Command\Z/, '')
    end

    def build_common_xml
      xml_builder { |xml| add_common_elements_to(xml) }
    end

    def xml_builder
      Nokogiri::XML::Builder.new(encoding: ENCODING) { |xml| yield(xml) }
    end

    def add_common_elements_to(xml)
      xml.AdCourierAPI do
        xml.Method method_name
        xml.APIKey
        xml.Account do
          xml.UserName
          xml.Password
        end
      end
    end

    def merge_common_xml_with(command_specific_xml)
      full_xml = build_common_xml
      merge(full_xml, command_specific_xml) if command_specific_xml
      full_xml
    end

    def merge(target, source)
      elements = get_elements_to_merge(source)
      elements.each{ |e| merge_element(e, target) }
    end

    def get_elements_to_merge(source)
      source.doc.root.children
    end

    def merge_element(element, target)
      target.doc.root.add_child element
    end

    def build_command_specific_xml_from(options)
      xml_builder { |xml| add_command_specifics(xml, options) }
    end

    def add_channels(xml, channels)
      xml.ChannelList do
        channels.each { |channel| add_channel(channel, xml) }
      end
    end

    def add_channel(channel, xml)
      xml.Channel do
        xml.ChannelId channel
      end
    end

    def broadbean_time(our_time)
      our_time.utc.iso8601
    end
  end
end