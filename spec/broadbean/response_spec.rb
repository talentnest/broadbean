require 'spec_helper.rb'

describe Broadbean::Response do
  describe '#new' do
    let(:payload) { double('Broadbean::Payload', standard_data: { id: nil, time: nil }, failure_message: nil, method_data: nil) }
    let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: 'xml_message') }

    before { Broadbean::Payload.stub(:new).and_return(payload) }

    it 'should create a Payload object with given http response body' do
      Broadbean::Payload.should_receive(:new).with(http_response.body)
      Broadbean::Response.new('Export', http_response)
    end
  end

  describe '#id' do
    context 'when there was HTTP transmission failure' do
      let(:http_response) { double('Net::HTTPServerError', code: 503, msg: 'Service Unavailable') }

      subject { Broadbean::Response.new('Export', http_response) }

      its(:id) { should be_nil }
    end

    context 'when HTTP transmission was OK' do
      let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
      let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

      subject { Broadbean::Response.new('Export', http_response) }

      its(:id) { should == 'slipstream-01-23-1232729100-12345'}
    end
  end

  describe '#time' do
    context 'when there was HTTP transmission failure' do
      let(:http_response) { double('Net::HTTPServerError', code: 503, msg: 'Service Unavailable') }

      subject { Broadbean::Response.new('Export', http_response) }

      its(:time) { should be_nil }
    end

    context 'when HTTP transmission was OK' do
      let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
      let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
      let(:response_time_in_rails_zone) do
        Time.strptime('2009-01-23T16:45:00Z', Broadbean::RESPONSE_TIME_FORMAT).in_time_zone(Time.zone)
      end

      subject { Broadbean::Response.new('Export', http_response) }

      its(:time) { should == response_time_in_rails_zone }
    end
  end

  describe '#failure?' do
    context 'when there was HTTP transmission failure' do
      let(:http_response) { double('Net::HTTPServerError', code: 503, msg: 'Service Unavailable') }

      subject { Broadbean::Response.new('Export', http_response) }

      its(:failure?) { should be_true }
    end

    context 'when HTTP transmission was OK' do
      context 'but Broadbean reports command failure' do
        let(:xml_message) { File.read('spec/support/files/command_failed.xml') }
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

        subject { Broadbean::Response.new('Export', http_response) }

        its(:failure?) { should be_true }
      end

      context 'and Broadbean reports no command failure' do
        let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

        subject { Broadbean::Response.new('Export', http_response) }

        its(:failure?) { should be_false }
      end
    end
  end

  describe '#payload' do
    context 'when there was HTTP transmission failure' do
      let(:http_response) do
        double('Net::HTTPServerError', class: Net::HTTPServerError, code: 503, msg: 'Service Unavailable')
      end

      subject { Broadbean::Response.new('Export', http_response) }

      its(:payload) { should == "HTTP Server Error: 503 Service Unavailable" }
    end

    context 'when HTTP transmission was OK' do
      context 'but Broadbean reports command failure' do
        let(:payload) do
          double('Broadbean::Payload', standard_data: { id: nil, time: nil }, failure_message: 'test', method_data: nil)
        end
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: 'xml_message') }

        subject { Broadbean::Response.new('Export', http_response) }

        before { Broadbean::Payload.stub(:new).and_return(payload) }

        its(:payload) { should == payload.failure_message }
      end

      context 'and Broadbean reports no command failure' do
        let(:payload) do
          double('Broadbean::Payload', standard_data: { id: nil, time: nil }, failure_message: nil, method_data: 'test')
        end
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: 'xml_message') }

        subject { Broadbean::Response.new('Export', http_response) }

        before { Broadbean::Payload.stub(:new).and_return(payload) }

        its(:payload) { should == payload.method_data }
      end
    end
  end
end