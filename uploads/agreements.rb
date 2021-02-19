# frozen_string_literal: true

AGREEMENT_INFO = {

  sf_tablename: 'soco__Agreement__c',

  predicate: "Id != null LIMIT #{Uploader::SOQL_RECORD_LIMIT}",

  sql_tablename: 'ImportSfAgreement',

  mapping: {
    Id: 'Id'
  }

}.freeze
