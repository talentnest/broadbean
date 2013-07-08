require 'broadbean/version'
require 'uri'
require 'broadbean/request'
require 'broadbean/response'
require 'broadbean/command'
require 'active_support/core_ext/string'

module Broadbean
  # https://github.com/rails/rails/issues/1366
  ActiveSupport::Inflector.inflections do |i|
    i.acronym 'URL'
    i.acronym 'HTTP'
  end

  URL          = URI.parse('https://api.adcourier.com/hybrid/hybrid.cgi')
  CONTENT_TYPE = 'text/xml'
  ENCODING     = 'utf-8'
  COMMANDS     = [:export, :advert_check, :status_check, :delete]

  @api_key  = nil
  @username = nil
  @password = nil

  class << self
    COMMANDS.each do |command|
      command_class = [command.to_s.classify, 'Command'].join

      define_method(command) do |command_params|
        c = Broadbean.const_get(command_class).new(command_params)
        c.authenticate(api_key, username, password)
        c
      end
    end
  end

  def self.init(api_key, username, password)
    @api_key  = api_key
    @username = username
    @password = password
  end

private

  class << self
    attr_reader :api_key, :username, :password
  end
end
