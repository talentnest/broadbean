require 'spec_helper'

describe Broadbean::Command do

  describe "#new" do
    let(:xml_doc) { File.read('spec/support/files/command.xml') }

    it "should create a Command XML doc" do
      subject.instance_variable_get(:@command_builder).to_xml.should == xml_doc
    end
  end

  describe "#authenticate" do
    let(:api_key)  { "654321" }
    let(:username) { "JDoe" }
    let(:password) { "pass123" }

    it "should set Broadbean credentials for the command" do
      subject.authenticate(api_key, username, password)

      xml = subject.instance_variable_get(:@command_builder).doc

      xml.at_css('APIKey').content.should   == api_key
      xml.at_css('UserName').content.should == username
      xml.at_css('Password').content.should == password
    end
  end

  describe "#execute" do
    let(:request) { double('Broadbean::Request', send_out: 'http_response') }
    let(:response) { double('Broadbean::Response', message: 'Success') }

    before do
      Broadbean::Request.stub(:new) { request }
      Broadbean::Response.stub(:new) { response }
    end

    it "should create a new Request" do
      command_builder = subject.instance_variable_get(:@command_builder)

      Broadbean::Request.should_receive(:new).with(command_builder.to_xml)
      subject.execute
    end

    it "should send out the Request" do
      request.should_receive(:send_out)
      subject.execute
    end

    it "should create a Response" do
      Broadbean::Response.should_receive(:new).with('', request.send_out)
      subject.execute
    end
  end

  describe "#failed?" do
    context "command not executed" do
      before { subject.stub(:executed?) { false } }

      it { subject.failed?.should be_false }
    end

    context "command executed" do
      before { subject.stub(:executed?) { true } }

      context "and not successful" do
        let(:response) { double('Broadbean::Response', failure?: true) }

        before { subject.instance_variable_set(:@response, response) }

        it { subject.failed?.should be_true }
      end

      context "and successful" do
        let(:response) { double('Broadbean::Response', failure?: false) }

        before { subject.instance_variable_set(:@response, response) }

        it { subject.failed?.should be_false }
      end
    end
  end

  describe "#result" do
    context "command not executed" do
      before { subject.stub(:executed?) { false } }

      it { subject.result.should be_nil}
    end

    context "command executed" do
      let(:response) { double('Broadbean::Response', payload: 'Success') }

      before do
        subject.stub(:executed?) { true }
        subject.instance_variable_set(:@response, response)
      end

      it { subject.result.should == response.payload }
    end
  end
end