require 'spec_helper'

describe Broadbean::ExportCommand do
  describe "#new" do
    let(:command_params) do
      {
        job_id:           1234,
        job_title:       'Test driver',
        job_reference:   'Testing',
        job_type:        'Permanent',
        location_id:      23,
        industry:        'Car',
        salary_from:      23000,
        salary_to:        32000,
        salary_currency: 'CAD',
        salary_per:      'year',
        skills:          'fast reflexes',
        job_description: 'Test drive cool cars',
        channels:        [:monster, :workopolis],
        apply_url:       "https://delta.talentnest.com/job/1234"
      }
    end

    context "when command options are given" do
      let(:xml_doc) { File.read('spec/support/files/export_command/export_command.xml') }

      it "should create non-authenticated Export command XML doc out of given parameters" do
        subject = Broadbean::ExportCommand.new(command_params)
        subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
      end
    end
  end

  describe "#configure" do
    let(:command_params) do
      { job_id: 1234 }
    end
    let(:xml_doc) { File.read('spec/support/files/export_command/configured.xml') }
    let(:options) do
      {
        style_sheet:            'test.css',
        display_menu:            false,
        force_step_one:          true,
        notify_on_delivery:     'page_url_here',
        redirect_on_completion: 'page_url_here',
        return_store_url:        true,
        automate:                false
      }
    end

    subject { Broadbean::ExportCommand.new(command_params) }

    it "should add Config XML element with the given params to Export command" do
      subject.configure(options)
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end