require 'spec_helper'

describe Broadbean::DeleteCommand do
  describe "#new" do
    let(:xml_doc) { File.read('spec/support/files/delete_command.xml') }
    let(:command_params) do
      {
          advert_id:     '123',
          job_reference: 'Testing',
          job_id:         321,
          limit:          1,
          from:           Time.new(2012,06,30),
          to:             Time.new(2012,07,30),
          channels:       [:monster, :workopolis]
      }
    end

    it "should create non-authenticated Delete command XML doc out of given command parameters" do
      subject = Broadbean::DeleteCommand.new(command_params)
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end