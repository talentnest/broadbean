module Broadbean
  class ExportCommand < Command

    def initialize(options=nil)
      super(build_command_specific_xml_from(options))
    end

    def configure(options={})
      config = build_config_xml_from(options)

      new_element = config.doc.root
      target = command_builder.doc.at_css('Account')
      insert_after(target, new_element)
    end

  private

    def add_command_specifics(xml, options)
      channels = options.delete(:channels)

      xml.root do
        add_advert(xml, options)
        add_channels(xml, channels) if channels
      end
    end

    def build_config_xml_from(options)
      xml_builder { |xml| add_config(xml, options) }
    end

    def add_config(xml, options)
      xml.Config do
        xml.Options do
          xml.StyleSheet           options[:style_sheet]
          xml.DisplayMenu          options[:display_menu]
          xml.ForceStep1           options[:force_step_one]
          xml.NotifyOnDelivery     options[:notify_on_delivery]
          xml.RedirectOnCompletion options[:redirect_on_completion]
          xml.ReturnStoreURL       options[:return_store_url]
          xml.Automate             options[:automate]
        end
      end
    end

    def add_advert(xml, advert)
      xml.Advert do
        xml.JobTitle       advert[:job_title]
        xml.JobReference   advert[:job_reference]
        xml.JobType        advert[:job_type]
        xml.Location_Id    advert[:location_id]
        xml.Industry       advert[:industry]
        xml.SalaryFrom     advert[:salary_from]
        xml.SalaryTo       advert[:salary_to]
        xml.SalaryCurrency advert[:salary_currency]
        xml.SalaryPer      advert[:salary_per]
        xml.Skills         advert[:skills]
        xml.JobDescription advert[:job_description]
        xml.Extension      advert[:apply_url], name: 'applyonline' if advert[:apply_url]
        xml.CustomField    advert[:job_id], name: 'job_id'
      end
    end

    def insert_after(target, new_element)
      target.add_next_sibling new_element
    end
  end
end