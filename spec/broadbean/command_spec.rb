require 'spec_helper'

describe Broadbean::Command do

  let(:command) { File.read('spec/support/files/message1.xml') }

  subject { Broadbean::Command.new(command) }

  describe "#new" do
    it "should create a new Request with the given XML command" do
      Broadbean::Request.should_receive(:new).with(command)
      subject
    end
  end

  describe "#execute" do
    let(:http_response) { double('Net::HTTPSuccess') }
    let(:request) { double('Broadbean::Request', send_out: http_response) }
    let(:response) { double('Broadbean::Response', message: 'Success') }

    before do
      Broadbean::Request.stub(:new) { request }
      Broadbean::Response.stub(:new).with(http_response) { response }
    end

    it "should send out a command request" do
      request.should_receive(:send_out)
      subject.execute
    end

    it "should create a new Response" do
      Broadbean::Response.should_receive(:new).with(http_response)
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