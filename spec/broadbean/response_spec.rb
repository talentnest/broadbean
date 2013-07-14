require 'spec_helper.rb'

describe Broadbean::Response do

  describe "#failure?" do
    context "when there was HTTP transmission failure" do
      let(:http_response) { double('Net::HTTPServerError', code: 503, msg: 'Service Unavailable') }

      subject { Broadbean::Response.new('Export', http_response) }

      it { subject.failure?.should be_true }
    end

    context "when HTTP transmission was OK" do
      context "but Broadbean reports command failure" do
        let(:xml_message) { File.read('spec/support/files/command_failed.xml') }
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

        subject { Broadbean::Response.new('Export', http_response) }

        it { subject.failure?.should be_true }
      end

      context "and Broadbean reports no command failure" do
        let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

        subject { Broadbean::Response.new('Export', http_response) }

        it { subject.failure?.should be_false }
      end
    end
  end

  describe "#payload" do
    context "when there was HTTP transmission failure" do
      let(:http_response) do
        double('Net::HTTPServerError', class: Net::HTTPServerError, code: 503, msg: 'Service Unavailable')
      end
      subject { Broadbean::Response.new('Export', http_response) }

      it { subject.payload.should == "HTTP Server Error: 503 Service Unavailable" }
    end

    context "when HTTP transmission was OK" do
      context "but Broadbean reports command failure" do
        let(:xml_message) { File.read('spec/support/files/command_failed.xml') }
        let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }

        subject { Broadbean::Response.new('Export', http_response) }

        it { subject.payload.should == 'Sorry command failed because of XYZ' }
      end

      context "and Broadbean reports no command failure" do
        context "for Export command" do
          let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:export_response) do
            { store_job_url: 'http://www.adcourier.com/' }
          end

          subject { Broadbean::Response.new('Export', http_response) }

          it { subject.payload.should == [export_response] }
        end

        context "for EnumeratedTypesCommand" do
          let(:xml_message) { File.read('spec/support/files/enumerated_types_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:enumerated_types_response) do
            {
              section: 'Currency',
              option: [
                { name: '£',   value: 'GBP' },
                { name: '€',   value: 'EUR' },
                { name: 'USD', value: 'USD' }
              ]
            }
          end

          subject { Broadbean::Response.new('EnumeratedTypes', http_response) }

          it { subject.payload.should == [enumerated_types_response] }
        end

        context "for ListChannels command" do
          let(:xml_message) { File.read('spec/support/files/list_channels_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:list_channels_response) do
            {
              channel_list: {
                channel: [
                  {
                    channel_id:   'cvlibrary',
                    channel_name: 'CV Library',
                    board_id:     '021'
                  },
                  {
                    channel_id:        'monsterxml',
                    channel_name:      'Monster XML',
                    board_id:          '479',
                    channel_summary:   'Any text set to appear to the user on broadcast-step-1',
                    free_to_post:      'true',
                    cost_per_post:     '$20.00',
                    quota_information: '3 slots remaining'
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'reed.co.uk',
                    board_id:     '294'
                  }
                ]
              }
            }
          end

          subject { Broadbean::Response.new('ListChannels', http_response) }

          it { subject.payload.should == [list_channels_response] }
        end

        context "for Delete command" do
          let(:xml_message) { File.read('spec/support/files/delete_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:advert1) do
            {
              advert: {
                id:            '14710',
                create_time:   '2009-01-23T16:45:11Z',
                consultant:    'user',
                team:          'team',
                office:        'office',
                user_name:     'John.Doe@hybridtest.com',
                job_title:     'Disbursements Manager',
                job_reference: 'job_ref',
                job_type:      'Permanent'
              },
              channel_list: {
                channel: [
                  {
                    channel_id:   'monsterxml',
                    channel_name: 'Monster XML',
                    channel_status: {
                      posted_time:       '2009-01-23T16:46:24Z',
                      removal_time:      '2009-01-28T09:35:52Z',
                      return_code:       '5',
                      return_code_class: 'Success',
                      value:             'Deleted'
                    }
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'Reed',
                    channel_status: {
                      posted_time:       '2009-01-23T16:46:24Z',
                      removal_time:      '2009-01-30T16:46:24Z',
                      return_code:       '10',
                      return_code_class: 'Failed',
                      value:             'Unsupported - board is not valid any longer.'
                    }
                  }
                ]
              }
            }
          end
          let(:advert2) do
            {
              advert: {
                id:            '14711',
                create_time:   '2009-02-23T16:45:11Z',
                consultant:    'user',
                team:          'team',
                office:        'office',
                user_name:     'John.Doe@hybridtest.com',
                job_title:     'Disbursements Chief',
                job_reference: 'job_ref',
                job_type:      'Permanent'
              },
              channel_list: {
                channel: [
                  {
                    channel_id:   'monsterxml',
                    channel_name: 'Monster XML',
                    channel_status: {
                      posted_time:       '2009-02-23T16:46:24Z',
                      removal_time:      '2009-02-28T09:35:52Z',
                      return_code:       '5',
                      return_code_class: 'Success',
                      value:             'Deleted'
                    }
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'Reed',
                    channel_status: {
                      posted_time:       '2009-02-23T16:46:24Z',
                      removal_time:      '2009-02-30T16:46:24Z',
                      return_code:       '10',
                      return_code_class: 'Failed',
                      value:             'Unsupported - board is not valid any longer.'
                    }
                  }
                ]
              }
            }
          end
          let(:deleted_adverts) { [advert1, advert2] }

          subject { Broadbean::Response.new('Delete', http_response) }

          it { subject.payload.should == deleted_adverts }
        end

        context "for StatusCheck command" do
          let(:xml_message) { File.read('spec/support/files/status_check_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:response) do
            {
              advert: {
                id:            '14710',
                create_time:   '2009-01-23T16:45:11Z',
                consultant:    'user',
                team:          'team',
                office:        'office',
                user_name:     'John.Doe@hybridtest.com',
                job_title:     'Disbursements Manager',
                job_reference: 'job_ref'
              },
              channel_list: {
                channel: [
                  {
                    channel_id:   'cvlibrary',
                    channel_name: 'CV Library',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      return_code: '21',
                      return_code_class: 'Pending',
                      value: 'Being delivered'
                    }
                  },
                  {
                    channel_id:   'monsterxml',
                    channel_name: 'Monster XML',
                    cost:         '175.00',
                    currency:     'GBP',
                    channel_status: {
                      posted_time:       '2009-01-23T16:46:24Z',
                      removal_time:      '2009-01-30T16:46:24Z',
                      return_code:       '0',
                      responses:         '0',
                      slots:             '1',
                      advert_url:        'http://jobsearch.monster.co.uk/getjob.asp?JobID=1234567',
                      return_code_class: 'Success',
                      value:             'Delivered'
                    }
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'Reed',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      posted_time:       '2009-01-23T16:46:22Z',
                      return_code:       '17',
                      responses:         '0',
                      slots:             '',
                      return_code_class: 'Failed',
                      value:             'Failed'
                    }
                  }
                ]
              }
            }
          end

          subject { Broadbean::Response.new('StatusCheck', http_response) }

          it { subject.payload.should == [response] }
        end

        context "for AdvertCheck command" do
          let(:xml_message) { File.read('spec/support/files/advert_check_command/success.xml') }
          let(:http_response) { double('Net::HTTPOK', class: Net::HTTPOK, body: xml_message) }
          let(:advert1) do
            {
              advert: {
                id:              '14710',
                create_time:     '2009-01-23T16:45:11Z',
                consultant:      'user',
                team:            'team',
                office:          'office',
                user_name:       'John.Doe@hybridtest.com',
                job_title:       'Disbursements Manager',
                job_reference:   'job_ref',
                job_type:        'Permanent',
                location_id:     '38640',
                industry:        'IT',
                salary_from:     '400.00',
                salary_to:       '500.00',
                salary_currency: 'GBP',
                salary_per:      'annum',
                salary_benefits: 'Benefits',
                skills:          'some skills',
                job_description: 'Nice description of an exported job'
              },
              contact: {
                contact_name:      'Consultant Name',
                contact_email:     'consultant@company.com',
                contact_telephone: '01234 567890'
              },
              channel_list: {
                channel: [
                  {
                    channel_id:   'cvlibrary',
                    channel_name: 'CV Library',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      value:             'Being delivered',
                      return_code:       '21',
                      return_code_class: 'Pending'
                    }
                  },
                  {
                    channel_id:     'monsterxml',
                    channel_name:   'Monster XML',
                    cost:           '175.00',
                    currency:       'GBP',
                    channel_status: {
                      value:             'Delivered',
                      posted_time:       '2009-01-23T16:46:24Z',
                      removal_time:      '2009-01-30T16:46:24Z',
                      return_code:       '0',
                      responses:         '0',
                      slots:             '1',
                      advert_url:        'http://jobsearch.monster.co.uk/getjob.asp?JobID=1234567',
                      return_code_class: 'Success'
                    }
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'Reed',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      value:             'Failed',
                      posted_time:       '2009-01-23T16:46:22Z',
                      return_code:       '17',
                      responses:         '0',
                      slots:             '',
                      return_code_class: 'Failed'
                    }
                  }
                ]
              }
            }
          end
          let(:advert2) do
            {
              advert: {
                id:              '14711',
                create_time:     '2009-02-23T16:45:11Z',
                consultant:      'user',
                team:            'team',
                office:          'office',
                user_name:       'John.Doe@hybridtest.com',
                job_title:       'Disbursements Chief',
                job_reference:   'job_ref',
                job_type:        'Permanent',
                location_id:     '38640',
                industry:        'IT',
                salary_from:     '400.00',
                salary_to:       '500.00',
                salary_currency: 'GBP',
                salary_per:      'annum',
                salary_benefits: 'Benefits',
                skills:          'some skills',
                job_description: 'Nice description of an exported job'
              },
              contact: {
                contact_name:      'Consultant Name',
                contact_email:     'consultant@company.com',
                contact_telephone: '01234 567890'
              },
              channel_list: {
                channel: [
                  {
                    channel_id:   'cvlibrary',
                    channel_name: 'CV Library',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      value:             'Being delivered',
                      return_code:       '21',
                      return_code_class: 'Pending'
                    }
                  },
                  {
                    channel_id:   'monsterxml',
                    channel_name: 'Monster XML',
                    cost:         '175.00',
                    currency:     'GBP',
                    channel_status: {
                      value:             'Delivered',
                      posted_time:       '2009-01-23T16:46:24Z',
                      removal_time:      '2009-01-30T16:46:24Z',
                      return_code:       '0',
                      responses:         '0',
                      slots:             '1',
                      advert_url:        'http://jobsearch.monster.co.uk/getjob.asp?JobID=1234567',
                      return_code_class: 'Success'
                    }
                  },
                  {
                    channel_id:   'reed',
                    channel_name: 'Reed',
                    cost:         '0.00',
                    currency:     'GBP',
                    channel_status: {
                      value:             'Failed',
                      posted_time:       '2009-01-23T16:46:22Z',
                      return_code:       '17',
                      responses:         '0',
                      slots:             '',
                      return_code_class: 'Failed'
                    }
                  }
                ]
              }
            }
          end
          let(:adverts) { [advert1, advert2] }

          subject { Broadbean::Response.new('AdvertCheck', http_response) }

          it { subject.payload.should == adverts }
        end
      end
    end
  end
end