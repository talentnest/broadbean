module Broadbean
  class DeleteCommand < Command

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
        filter       = options[:filter]
        times        = filter[:times] if filter
        channel_list = options[:channel_list]
      end

      builder = Nokogiri::XML::Builder.new(encoding: Broadbean::ENCODING) do |xml|
        xml.AdCourierAPI do
          xml.Method Broadbean::METHOD_NAME[:delete]
          xml.APIKey Broadbean::API_KEY

          if account
            xml.Account { add_single_xml_elements(xml, account_tags, account) }
          end

          if options
            xml.Options do
              if filter
                xml.Filter do
                  xml.JobReference filter[:job_reference] if filter[:job_reference]
                  if times
                    xml.Times do
                      xml.TimeFrom times[:time_from] if times[:time_from]
                    end
                  end
                  xml.Id filter[:id] if filter[:id]
                  if filter[:custom_fields]
                    filter[:custom_fields].each { |cf| xml.CustomField cf[:value], name: cf[:name] }
                  end
                  xml.Limit filter[:limit] if filter[:limit]
                end
              end

              if channel_list
                xml.ChannelList do
                  channel_list.each do |channel|
                    xml.Channel do
                      xml.ChannelId channel[:channel_id]
                    end
                  end
                end
              end
            end
          end
        end
      end

      builder.to_xml
    end
  end
end