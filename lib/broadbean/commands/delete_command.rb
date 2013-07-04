module Broadbean
  class DeleteCommand < Command

    def initialize(options={})
      super(build_command_specific_xml_from(options))
    end

  private

    def add_command_specifics(xml, options)
      job_ref   = options[:job_reference]
      advert_id = options[:advert_id]
      job_id    = options[:job_id]
      limit     = options[:limit]
      from      = options[:from]
      to        = options[:to]
      channels  = options[:channels]

      xml.root do
        xml.Options do
          xml.Filter do
            xml.JobReference job_ref if job_ref
            if from || to
              xml.Times do
                xml.TimeFrom broadbean_time(from) if from
                xml.TimeTo broadbean_time(to) if to
              end
            end
            xml.Id advert_id if advert_id
            xml.CustomField job_id, name: 'job_id' if job_id
            xml.Limit limit if limit
          end
          add_channels(xml, channels) if channels
        end
      end
    end
  end
end