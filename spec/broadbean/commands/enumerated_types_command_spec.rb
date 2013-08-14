require 'spec_helper'

describe Broadbean::EnumeratedTypesCommand do
  context "when retrieving additional locations from a certain time" do
    it_should_behave_like "a Broadbean Command" do
      let(:xml_doc) { File.read('spec/support/files/enumerated_types_command/location_additional.xml') }
      let(:command_params) do
        {
          for:  :location,
          get:  :additional,
          from: Time.new(2012,07,06)
        }
      end
    end
  end

  context "when retrieving locations updated from a certain time" do
    it_should_behave_like "a Broadbean Command" do
      let(:xml_doc) { File.read('spec/support/files/enumerated_types_command/location_updated.xml') }
      let(:command_params) do
        {
          for:  :location,
          get:  :updated,
          from: Time.new(2012,07,06)
        }
      end
    end
  end

  context "when retrieving only countries" do
    it_should_behave_like "a Broadbean Command" do
      let(:xml_doc) { File.read('spec/support/files/enumerated_types_command/location_countries.xml') }
      let(:command_params) do
        {
          for: :location,
          get: :countries
        }
      end
    end
  end

  context "when retrieving child locations under a certain parent location" do
    it_should_behave_like "a Broadbean Command" do
      let(:xml_doc) { File.read('spec/support/files/enumerated_types_command/location_children.xml') }
      let(:parent_location_id) { 13 }
      let(:command_params) do
        {
          for: :location,
          get: :children,
          of:  parent_location_id
        }
      end
    end
  end
end