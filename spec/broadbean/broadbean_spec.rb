require 'spec_helper'

describe Broadbean do
  let(:api_key)  { "654321" }
  let(:username) { "JDoe" }
  let(:password) { "pass123" }

  subject { Broadbean }

  describe "#init" do
    it "should set up Broadbean credentials" do
      subject.init(api_key, username, password)

      subject.instance_variable_get(:@api_key).should  == api_key
      subject.instance_variable_get(:@username).should == username
      subject.instance_variable_get(:@password).should == password
    end
  end

  context do
    let(:params) { "some params" }

    describe ".export" do
      let(:export_command) { double('Broadbean::ExportCommand', authenticate: nil) }

      before { Broadbean::ExportCommand.stub(:new).and_return(export_command) }

      it "should create ExportCommand with given params" do
        Broadbean::ExportCommand.should_receive(:new).with(params)
        subject.export(params)
      end
    end

    describe ".advert_check" do
      let(:advert_check_command) { double('Broadbean::AdvertCheckCommand', authenticate: nil) }

      before { Broadbean::AdvertCheckCommand.stub(:new).and_return(advert_check_command) }

      it "should create AdvertCheckCommand with given params" do
        Broadbean::AdvertCheckCommand.should_receive(:new).with(params)
        subject.advert_check(params)
      end
    end

    describe ".delete" do
      let(:delete_command) { double('Broadbean::DeleteCommand', authenticate: nil) }

      before { Broadbean::DeleteCommand.stub(:new).and_return(delete_command) }

      it "should create DeleteCommand with given params" do
        Broadbean::DeleteCommand.should_receive(:new).with(params)
        subject.delete(params)
      end
    end
  end
end