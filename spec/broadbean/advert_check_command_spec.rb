require 'spec_helper'

describe Broadbean::AdvertCheckCommand do
  describe "#new" do
    let(:command_parameters) { File.read('spec/support/files/advert_check_command.json') }
    let(:xml_command) { File.read('spec/support/files/advert_check_command.xml') }

    it "should create XML delete command out of given command parameters in JSON format" do
      subject = Broadbean::AdvertCheckCommand.new(command_parameters)
      subject.instance_variable_get(:@command).should == xml_command
    end
  end
end