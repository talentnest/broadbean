require 'broadbean'
require 'broadbean/commands/export_command'
require 'broadbean/commands/delete_command'
require 'broadbean/commands/advert_check_command'
require 'broadbean/commands/status_check_command'
require 'broadbean/response'

require 'support/vcr'

# Require shared examples
Dir["./spec/shared_examples/*.rb"].each {|f| require f}