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

  URL                  = URI.parse('https://api.adcourier.com/hybrid/hybrid.cgi')
  CONTENT_TYPE         = 'text/xml'
  ENCODING             = 'utf-8'
  RESPONSE_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%z'
  COMMANDS             = [:export, :advert_check, :status_check, :delete, :enumerated_types, :list_channels]

  @api_key = @username = @password = nil

  class << self
    def init(api_key, username, password)
      @api_key  = api_key
      @username = username
      @password = password
    end

    # create Broadbean.export(), Broadbean.advert_check(), etc.
    COMMANDS.each do |name|
      define_method(name) { |params| new_authenticated_command(command_class(name), params) }
    end
  end

private

  class << self
    attr_reader :api_key, :username, :password

    def new_authenticated_command(class_name, params)
      c = Broadbean.const_get(class_name).new(params)
      c.authenticate(api_key, username, password)
      c
    end

    def command_class(name)
      [name.to_s.classify, 'Command'].join
    end
  end
end
