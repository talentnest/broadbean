require 'spec_helper'

describe Broadbean::StatusCheckCommand do
  describe "#new" do
    let(:xml_doc) { File.read('spec/support/files/status_check_command.xml') }
    let(:command_params) do
      {
        advert_id:     '123',
        job_reference: 'Testing',
        from:           Time.new(2012,06,30),
        job_id:         321
      }
    end

    it "should create non-authenticated StatusCheck command XML doc out of given parameters" do
      subject = Broadbean::StatusCheckCommand.new(command_params)
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end