# frozen_string_literal: true

CAMPAIGNMEMBER_INFO = {

  sf_tablename: 'CampaignMember',

  predicate: "CreatedDate >= #{Uploader::CUTOFF_DATE}T00:00:00Z LIMIT #{Uploader::SOQL_RECORD_LIMIT}",

  sql_tablename: 'ImportSfCampaignmember',

  mapping: {
    Id: 'Id'
  }

}.freeze
