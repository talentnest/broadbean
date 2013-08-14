require 'spec_helper'

describe Broadbean::StatusCheckCommand do
  it_should_behave_like "a Broadbean Command" do
    let(:xml_doc) { File.read('spec/support/files/status_check_command/status_check_command.xml') }
    let(:command_params) do
      {
        advert_id:     '123',
        job_reference: 'Testing',
        from:           Time.new(2012,06,30),
        job_id:         321
      }
    end
  end
end