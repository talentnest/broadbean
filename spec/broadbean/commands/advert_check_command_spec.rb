require 'spec_helper'

describe Broadbean::AdvertCheckCommand do
  describe "#new" do
    let(:xml_doc) { File.read('spec/support/files/advert_check_command.xml') }
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

    it "should create non-authenticated AdvertCheck command XML doc out of given parameters" do
      subject = Broadbean::AdvertCheckCommand.new(command_params)
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end