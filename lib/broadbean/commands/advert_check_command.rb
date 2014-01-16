module Broadbean
  class AdvertCheckCommand < Command

    # Advert's channel status codes returned by AdvertCheck for each channel (board)

    POSTED_CODES = {
      '0' => :delivered
    }

    REMOVED_CODES = {
      '1' => :delete_request,
      '5' => :deleted,
      '6' => :expired
    }

    PENDING_CODES = {
      '19' => :future,
      '21' => :waiting,
      '22' => :authreq,
      '23' => :holding,
      '24' => :processing,
      '25' => :edit_pending
    }

    FAILED_CODES = {
      '16' => :denied,
      '17' => :failed_ack,
      '18' => :failed,
      '20' => :unknown
    }

    STATUS_CODES = [POSTED_CODES, REMOVED_CODES, PENDING_CODES, FAILED_CODES].inject(Hash.new) do |result_hash, codes|
      result_hash.merge!(codes)
    end

    def initialize(options=nil)
      super(build_command_specific_xml_from(options))
    end

  private

    def add_command_specifics(xml, options)
      advert_id = options[:advert_id]
      job_ref   = options[:job_reference]
      from      = options[:from]
      to        = options[:to]
      job_id    = options[:job_id]
      limit     = options[:limit]

      xml.root do
        xml.Options do
          xml.Filter do
            xml.AdvertId advert_id if advert_id
            xml.JobReference job_ref if job_ref
            if from || to
              xml.Times do
                xml.TimeFrom broadbean_time(from) if from
                xml.TimeTo broadbean_time(to) if to
              end
            end
            xml.CustomField job_id, name: 'job_id' if job_id
            xml.Limit limit if limit
          end
        end
      end
    end
  end
end