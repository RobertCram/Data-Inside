# frozen_string_literal: true

CAMPAIGN_INFO = {

  sf_tablename: 'Campaign',

  predicate: "Id != null LIMIT #{Uploader::SOQL_RECORD_LIMIT}",

  sql_tablename: 'ImportSfCampaign',

  mapping: {
    VersieId: 'Id'
  }

}.freeze
