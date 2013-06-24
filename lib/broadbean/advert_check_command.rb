module Broadbean
  class AdvertCheckCommand < Command

    def initialize(command_params)
      super(build_command(command_params))
    end

  private

    def build_command(command_params)
      command_params = to_hash(command_params)
      command_params = command_params[:command_parameters]

      account = command_params[:account]
      options = command_params[:options]

      if options
        filter          = options[:filter]
        times           = filter[:times] if filter
        all_desc_fields = options[:all_desc_fields]
        vac_extensions  = options[:vac_extensions]
      end

      builder = Nokogiri::XML::Builder.new(encoding: Broadbean::ENCODING) do |xml|
        xml.AdCourierAPI do
          xml.Method Broadbean::METHOD_NAME[:advert_check]
          xml.APIKey Broadbean::API_KEY

          if account
            xml.Account { add_single_xml_elements(xml, account_tags, account) }
          end

          if options
            xml.Options do
              if filter
                xml.Filter do
                  xml.AdvertId     filter[:advert_id]     if filter[:advert_id]
                  xml.JobReference filter[:job_reference] if filter[:job_reference]

                  if times
                    xml.Times do
                      xml.TimeFrom times[:time_from] if times[:time_from]
                      xml.TimeTo   times[:time_to]   if times[:time_to]
                    end
                  end

                  if filter[:custom_fields]
                    filter[:custom_fields].each { |cf| xml.CustomField cf[:value], name: cf[:name] }
                  end

                  xml.Limit filter[:limit] if filter[:limit]
                end
              end

              xml.AllDescFields all_desc_fields if all_desc_fields
              xml.VacExtensions vac_extensions  if vac_extensions
            end
          end
        end
      end

      builder.to_xml
    end
  end
end