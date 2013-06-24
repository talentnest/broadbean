require 'spec_helper'

describe Broadbean::ExportCommand do
  describe "#new" do
    let(:command_parameters) { File.read('spec/support/files/export_command.json') }
    let(:xml_command) { File.read('spec/support/files/export_command.xml') }

    it "should create XML export command out of given command parameters in JSON format" do
      subject = Broadbean::ExportCommand.new(command_parameters)
      subject.instance_variable_get(:@command).should == xml_command
    end
  end
end