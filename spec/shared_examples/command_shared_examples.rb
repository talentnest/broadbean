shared_examples "a Broadbean Command" do
  let(:command) { subject.class.new(command_params) }

  it "should create non-authenticated #{subject.class.name} XML doc out of given command parameters" do
    command.instance_variable_get(:@command_builder).to_xml.should == xml_doc
  end
end