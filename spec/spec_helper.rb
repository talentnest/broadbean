require 'broadbean'
require 'broadbean/response'
require 'broadbean/payload'
Dir["./lib/broadbean/commands/*.rb"].each {|f| require f} # Require all commands

require 'support/vcr'

Dir["./spec/shared_examples/*.rb"].each {|f| require f} # Require shared examples