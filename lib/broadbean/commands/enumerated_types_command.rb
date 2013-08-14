module Broadbean
  class EnumeratedTypesCommand < Command

    def initialize(options=nil)
      super(build_command_specific_xml_from(options))
    end

    private

    def add_command_specifics(xml, options)
      section   = options[:for]
      retrieve  = (options[:get] == :children) ? :start_from : options[:get]
      time_from = options[:from]
      parent_id = options[:of]

      xml.root do
        xml.Options do
          xml.Filter do
            xml.Section section.to_s.camelize
            if section == :location
              xml.SubSection do
                xml.Retrieve retrieve.to_s.camelize
                if [:additional, :updated].include?(retrieve)
                  xml.Times do
                    xml.TimeFrom broadbean_time(time_from)
                  end
                elsif retrieve == :start_from
                  xml.StartId parent_id
                end
              end
            end
          end
        end
      end
    end
  end
end