require 'spec_helper'

describe Broadbean::ListChannelsCommand do
  describe "#new" do
    let(:xml_doc) { File.read('spec/support/files/list_channels_command.xml') }

    it "should create non-authenticated List Channels command XML doc" do
      subject = Broadbean::ListChannelsCommand.new
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end