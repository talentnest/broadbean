require 'broadbean/version'
require 'uri'
require 'broadbean/request'
require 'broadbean/response'
require 'broadbean/command'

module Broadbean
  # https://github.com/rails/rails/issues/1366
  ActiveSupport::Inflector.inflections { |i| i.acronym "URL" }

  URL           = URI.parse('https://api.adcourier.com/hybrid/hybrid.cgi')
  CONTENT_TYPE  = 'text/xml'
  ENCODING      = 'utf-8'
  API_KEY       = '123456789'

  METHOD_NAME = {
    export:                 'Export',
    advert_check:           'AdvertCheck',
    status_check:           'StatusCheck',
    delete:                 'Delete',
    resend_without_changes: 'ResendWithoutChanges',
    authorisation_update:   'AuthorisationUpdate',
    retrieve_applications:  'RetrieveApplications',
    applicant_update:       'ApplicantUpdate',
    enumerated_types:       'EnumeratedTypes',
    fields_check:           'FieldsCheck',
    list_channels:          'ListChannels',
    list_users:             'ListUsers',
    add_user:               'AddUser',
    delete_user:            'DeleteUser'
  }
end
