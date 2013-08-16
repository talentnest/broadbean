require 'spec_helper.rb'

describe Broadbean::Payload do

  subject { Broadbean::Payload.new(xml_message) }

  describe "#failure_message" do
    context "when Broadbean reports command failure" do
      let(:xml_message) { File.read('spec/support/files/command_failed.xml') }

      its(:failure_message) { should == 'Sorry command failed because of XYZ' }
    end

    context "when Broadbean does not report command failure" do
      let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }

      its(:failure_message) { should be_nil }
    end
  end

  describe "#standard_data" do
    let(:xml_message)   { File.read('spec/support/files/export_command/success.xml') }
    let(:response_time_in_rails_zone) do
      Time.strptime('2009-01-23T16:45:00Z', Broadbean::RESPONSE_TIME_FORMAT).in_time_zone(Time.zone)
    end
    let(:standard_data) do
      {
        id:   'slipstream-01-23-1232729100-12345',
        time: response_time_in_rails_zone
      }
    end

    its(:standard_data) { should == standard_data }
  end


  describe "#method_data" do

    context "for Export command" do
      let(:xml_message) { File.read('spec/support/files/export_command/success.xml') }
      let(:export_data) do
        { store_job_url: 'http://www.adcourier.com/' }
      end

      it { subject.method_data('Export').should == [export_data] }
    end

    context "for EnumeratedTypesCommand" do
      let(:xml_message) { File.read('spec/support/files/enumerated_types_command/success.xml') }
      let(:enumerated_types_data) do
        {
          section: 'Currency',
          option: [
            { name: '£',   value: 'GBP' },
            { name: '€',   value: 'EUR' },
            { name: 'USD', value: 'USD' }
          ]
        }
      end

      it { subject.method_data('EnumeratedTypes').should == [enumerated_types_data] }
    end

    context "for ListChannels command" do
      let(:xml_message) { File.read('spec/support/files/list_channels_command/success.xml') }
      let(:list_channels_data) do
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

      it { subject.method_data('ListChannels').should == [list_channels_data] }
    end

    context "for Delete command" do
      let(:xml_message) { File.read('spec/support/files/delete_command/success.xml') }
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

      it { subject.method_data('Delete').should == deleted_adverts }
    end

    context "for StatusCheck command" do
      let(:xml_message) { File.read('spec/support/files/status_check_command/success.xml') }
      let(:status_check_data) do
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

      it { subject.method_data('StatusCheck').should == [status_check_data] }
    end

    context "for AdvertCheck command" do
      let(:xml_message) { File.read('spec/support/files/advert_check_command/success.xml') }
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

      it { subject.method_data('AdvertCheck').should == adverts }
    end
  end
end