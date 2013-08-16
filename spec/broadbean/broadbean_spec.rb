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

    describe ".status_check" do
      let(:status_check_command) { double('Broadbean::StatusCheckCommand', authenticate: nil) }

      before { Broadbean::StatusCheckCommand.stub(:new).and_return(status_check_command) }

      it "should create StatusCheckCommand with given params" do
        Broadbean::StatusCheckCommand.should_receive(:new).with(params)
        subject.status_check(params)
      end
    end

    describe ".enumerated_types" do
      let(:enumerated_types_command) { double('Broadbean::EnumeratedTypesCommand', authenticate: nil) }

      before { Broadbean::EnumeratedTypesCommand.stub(:new).and_return(enumerated_types_command) }

      it "should create EnumeratedTypesCommand with given params" do
        Broadbean::EnumeratedTypesCommand.should_receive(:new).with(params)
        subject.enumerated_types(params)
      end
    end

    describe ".list_channels" do
      let(:list_channels_command) { double('Broadbean::ListChannelsCommand', authenticate: nil) }

      before { Broadbean::ListChannelsCommand.stub(:new).and_return(list_channels_command) }

      it "should create ListChannelsCommand" do
        Broadbean::ListChannelsCommand.should_receive(:new)
        subject.list_channels
      end
    end
  end
end