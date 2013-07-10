require 'spec_helper'

describe Broadbean::DeleteCommand do
  describe "#new" do
    it_should_behave_like "a Broadbean Command" do
      let(:xml_doc) { File.read('spec/support/files/delete_command/delete_command.xml') }
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
    end
  end
end