# frozen_string_literal: true

require './uploader'

ACCOUNT_INFO = {

  sf_tablename: 'Account',

  predicate: <<~SOQL,
    Id != null LIMIT #{Uploader::SOQL_RECORD_LIMIT}
  SOQL

  sql_tablename: 'ImportSfAccount',

  mapping: {
    Id: 'Id',
    AdresvolledigC: 'Adres_volledig__c',  
    PostadresLandC: 'Postadres_Land__c',
    RecordTypeId: 'RecordTypeId'    
  },

}.freeze
