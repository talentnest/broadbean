require 'spec_helper'

describe Broadbean::DeleteCommand do
  describe "#new" do
    let(:command_parameters) { File.read('spec/support/files/delete_command.json') }
    let(:xml_command) { File.read('spec/support/files/delete_command.xml') }

    it "should create XML delete command out of given command parameters in JSON format" do
      subject = Broadbean::DeleteCommand.new(command_parameters)
      subject.instance_variable_get(:@command).should == xml_command
    end
  end
end