module Broadbean
  class StatusCheckCommand < Command

    def initialize(options=nil)
      super(build_command_specific_xml_from(options))
    end

    private

    def add_command_specifics(xml, options)
      advert_id = options[:advert_id]
      job_ref   = options[:job_reference]
      from      = options[:from]
      job_id    = options[:job_id]

      xml.root do
        xml.Options do
          xml.Filter do
            xml.AdvertId advert_id if advert_id
            xml.JobReference job_ref if job_ref
            if from
              xml.Times do
                xml.TimeFrom broadbean_time(from) if from
              end
            end
            xml.CustomField job_id, name: 'job_id' if job_id
          end
        end
      end
    end
  end
end