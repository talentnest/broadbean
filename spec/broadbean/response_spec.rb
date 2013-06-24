require 'spec_helper.rb'

describe Broadbean::Response do

  describe "#failure?" do
    context "there was http transmission failure" do
      let(:http_response) { double('Net::HTTPServerError', code: 503, msg: 'Service Unavailable') }

      subject { Broadbean::Response.new(http_response) }

      it { subject.failure?.should be_true }
    end

    context "http transmission was ok" do
      context "and Broadbean reports command failure" do
        let(:xml_message) { File.read('spec/support/files/command_failed.xml') }
        let(:http_response) { double('Net::HTTPSuccess', class: Net::HTTPSuccess, body: xml_message) }

        subject { Broadbean::Response.new(http_response) }

        it { subject.failure?.should be_true }
      end

      context "and Broadbean reports no command failure" do
        let(:xml_message) { File.read('spec/support/files/command_success.xml') }
        let(:http_response) { double('Net::HTTPSuccess', class: Net::HTTPSuccess, body: xml_message) }

        subject { Broadbean::Response.new(http_response) }

        it { subject.failure?.should be_false }
      end
    end
  end

  describe "#payload" do
    context "there was a failure" do
      #it "should return the failure message"
    end

    context "there was no failure" do
      #it "should return response payload"
    end
  end
end