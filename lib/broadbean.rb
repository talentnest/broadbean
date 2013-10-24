require 'broadbean/version'
require 'uri'
require 'broadbean/request'
require 'broadbean/response'
require 'broadbean/payload'
require 'broadbean/command'
require 'active_support/core_ext/string'

module Broadbean
  # https://github.com/rails/rails/issues/1366
  ActiveSupport::Inflector.inflections do |i|
    i.acronym 'URL'
    i.acronym 'HTTP'
  end

  URL                      = URI.parse('https://api.adcourier.com/hybrid/hybrid.cgi')
  CONTENT_TYPE             = 'text/xml'
  ENCODING                 = 'utf-8'
  RESPONSE_TIME_FORMAT     = '%Y-%m-%dT%H:%M:%S%z'
  COMMANDS                 = [:export, :advert_check, :status_check, :delete, :enumerated_types, :list_channels]
  ADVERT_NOT_FOUND_MESSAGE = 'Not found'
  DELIVERY_NOTICE_METHOD   = 'StatusCheck'

  ADVERT_DELIVERED_STATUS  = 'Delivered'
  ADVERT_PROCESSING_STATUS = 'Processing'
  ADVERT_REMOVED_STATUS    = 'Deleted'
  ADVERT_UNKNOWN_STATUS    = 'Unknown'
  ADVERT_FUTURE_STATUS     = 'Future'

  class << self
    def init(api_key, username, password)
      Thread.current[:broadbean_api_key]  = api_key
      Thread.current[:broadbean_username] = username
      Thread.current[:broadbean_password] = password
    end

    %w(api_key username password).each do |var|
      define_method(var) { Thread.current[:"broadbean_#{var}"] }
    end

    # create Broadbean.export(), Broadbean.advert_check(), etc.
    COMMANDS.each do |name|
      define_method(name) { |params=nil| new_authenticated_command(command_class(name), params) }
    end

private

    COMMANDS_WITH_PLURAL_NAME = [:enumerated_types, :list_channels]

    def new_authenticated_command(class_name, params)
      c = Broadbean.const_get(class_name).new(params)
      c.authenticate(api_key, username, password)
      c
    end

    def command_class(name)
      "#{command_prefix(name)}Command"
    end

    def command_prefix(name)
      COMMANDS_WITH_PLURAL_NAME.include?(name) ? prefix(name).pluralize : prefix(name)
    end

    def prefix(name)
      name.to_s.classify
    end
  end
end
