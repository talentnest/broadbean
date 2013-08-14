require 'spec_helper'

describe Broadbean::ListChannelsCommand do
  it_should_behave_like "a Broadbean Command" do
    let(:xml_doc) { File.read('spec/support/files/list_channels_command/list_channels_command.xml') }
    let(:command_params) { }
  end
end