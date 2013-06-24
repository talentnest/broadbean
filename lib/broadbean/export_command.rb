module Broadbean
  class ExportCommand < Command

    def initialize(command_params)
      super(build_command(command_params))
    end

  private

    def build_command(command_params)
      command_params = to_hash(command_params)
      command_params = command_params[:command_parameters]

      account           = command_params[:account]
      config            = command_params[:config]
      options           = config[:options] if config
      advert            = command_params[:advert]
      contact           = command_params[:contact]
      channel_list      = command_params[:channel_list]
      data_manipulation = command_params[:data_manipulation]

      builder = Nokogiri::XML::Builder.new(encoding: Broadbean::ENCODING) do |xml|
        xml.AdCourierAPI do
          xml.Method Broadbean::METHOD_NAME[:export]
          xml.APIKey Broadbean::API_KEY

          if account
            xml.Account { add_single_xml_elements(xml, account_tags, account) }
          end

          if config
            xml.Config do
              if options
                xml.Options { add_single_xml_elements(xml, config_options_tags, options) }
              end
            end
          end

          if advert
            xml.Advert do
              add_single_xml_elements(xml, advert_tags, advert)
              add_multiple_xml_elements(xml, advert_tags_multiple, advert)
            end
          end

          if contact
            xml.Contact { add_single_xml_elements(xml, contact_tags, contact) }
          end

          if channel_list
            xml.ChannelList do
              channel_list.each do |channel_info|
                xml.Channel do
                  add_single_xml_elements(xml, channel_tags, channel_info)
                  add_multiple_xml_elements(xml, channel_tags_multiple, channel_info)
                end
              end
            end
          end

          if data_manipulation
            xml.DataManipulation do
              if data_manipulation[:do]
                xml.Do { add_single_xml_elements(xml, data_manipulation_tags, data_manipulation[:do]) }
              end
            end
          end
        end
      end

      builder.to_xml
    end

    def advert_tags
      %w{
        job_title
        job_reference
        job_type
        location_id
        industry
        salary_from
        salary_to
        salary_currency
        salary_per
        salary_benefits
        skills
        summary
        client_details
        job_description
        profile
        job_offer
      }
    end

    def advert_tags_multiple
      %w{
        vac_extensions
        extensions
        custom_fields
      }
    end

    def config_options_tags
      %w{
        style_sheet
        display_menu
        force_step_1
        notify_on_delivery
        redirect_on_completion
        return_store_url
        automate
      }
    end

    def contact_tags
      %w{
        contact_name
        contact_email
        contact_telephone
        contact_address
        contact_company
      }
    end

    def channel_tags
      %w{
        channel_id
      }
    end

    def channel_tags_multiple
      %w{
        custom_fields
        extensions
      }
    end

    def data_manipulation_tags
      %w{
        field
        simple_op
        value
      }
    end
  end
end