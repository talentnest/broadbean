require 'spec_helper'

describe Broadbean::ExportCommand do
  describe "#new" do
    let(:job_id) { 1234 }
    let(:command_params) do
      {
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
        channels:        [:monster, :workopolis]
      }
    end

    context "when command options are given" do
      let(:xml_doc) { File.read('spec/support/files/export_command/export_command.xml') }

      it "should create non-authenticated Export command XML doc out of given parameters" do
        subject = Broadbean::ExportCommand.new(job_id, command_params)
        subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
      end
    end

    context "when only job_id is given" do
      let(:xml_doc) { File.read('spec/support/files/export_command/blank.xml') }

      it "should create non-authenticated Export command XML doc with other required elements having a blank value" do
        subject = Broadbean::ExportCommand.new(job_id)
        subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
      end
    end
  end

  describe "#configure" do
    let(:job_id) { 1234 }
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

    subject { Broadbean::ExportCommand.new(job_id) }

    it "should add Config XML element with the given params to Export command" do
      subject.configure(options)
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end
end