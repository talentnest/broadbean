require 'spec_helper'

describe Broadbean::Request do

  let(:message) { File.read('spec/support/files/message1.xml') }

  subject { Broadbean::Request.new(message) }

  describe "#send_out" do
    it "should send a request to Broadbean" do
      Net::HTTP.should_receive(:start).with(Broadbean::URL.host, Broadbean::URL.port, use_ssl: true)
      subject.send_out
    end

    it "should return a response from Broadbean" do
      VCR.use_cassette('request/send') do
        response = subject.send_out
        response.code.should == '200'
        response.message.should == 'OK'
      end
    end
  end
end