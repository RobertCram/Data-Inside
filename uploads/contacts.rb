# frozen_string_literal: true

require './uploader'

CONTACT_INFO = {

  sf_tablename: 'Contact',

  predicate: <<~SOQL,
    AccountId != null AND (CALC_Einddatum_Alle_Giften__c >= #{Uploader::CUTOFF_DATE} OR CreatedDate >= #{Uploader::CUTOFF_DATE}T00:00:00Z) LIMIT #{Uploader::SOQL_RECORD_LIMIT}
  SOQL

  sql_tablename: 'ImportSfContact',

  mapping: {
    Accountid: 'AccountId',
    Birthdate: 'Birthdate',
    Createddate: 'CreatedDate',
    # SocoStartDate: ?
    Donotcall: 'DoNotCall',
    Hasoptedoutofemail: 'HasOptedOutofEMail',
    Id: 'Id',
    # NoDirectMailC: ?
    # NoEMailsC: ?
    NoPostalMailC: 'Geen_Magazine__c',
    SocoActiveC: 'soco__Active__c',
    # SocoAgeC: ? - geboortedatum wordt al meegestuurd
    # SocoEndDateC: ?
    SocoSexeC: 'soco__n_Gender__c',
    SocoOriginatingCampaignC: 'soco__Originating_Campaign__c',
    SocoStatusC: 'soco__Status__c',
    NoAcceptgiro: 'Geen_Acceptgiro__c',
    socoBillingZipCode: 'Account.soco__Billing_Zipcode__c',
    socoBillingHousenumber: 'Account.soco__Billing_Housenumber__c',
    socoBillingSuffix: 'Account.soco__Billing_Suffix__c',
    AccountType: 'Account.Type'
  },

  converters: {
    Createddate: Uploader.method(:datetime_to_date)
  }

}.freeze
