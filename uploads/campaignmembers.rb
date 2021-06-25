# frozen_string_literal: true

def datumc(value, values, _)
  !value.nil? ? Uploader.quotedstring(value) : Uploader.datetime_to_date(values['createddate'])
end

def parentname(_, values, _)
  value = values['campaign.name']
  parent_value = values['campaign.parent.name']
  Uploader.quotedstring(values['campaign.parentid'].nil? ? value : parent_value)
end

CAMPAIGNMEMBER_INFO = {

  sf_tablename: 'CampaignMember',

  predicate: "LastModifiedDate >= #{Uploader::CUTOFF_DATE}T00:00:00Z LIMIT #{Uploader::SOQL_RECORD_LIMIT}",

  sql_tablename: 'ImportSfCampaignmember',

  mapping: {
    # CampaignmemberMigrationIDc: ?
    Id: 'Id',
    ContactId: 'ContactId',
    CampaignId: 'CampaignId',
    # socoPaymentReferencec: ? houden we niet bij, maar wel frequentie en bedrag
    Gift_Frequentie: 'Gift_frequentie__c',
    BedragC: 'Bedrag__c',
    Status: 'Status',
    DatumC: 'Datum__c',
    Incentive: 'Campaign.Gevraagd_bedrag__c', # staat al bij campagne
    CampaignName: 'Campaign.Name', # staat al bij campagne
    ContactResultaat: 'Contactresultaat__c',
    Mailpack: 'Campaign.Uiting__c', # staat al bij campagne
    CampaignCampagneKanaalc: 'Campaign.Campagnekanaal__c'  # staat al bij campagne
  },

  converters: {
    DatumC: method(:datumc),
    CampaignName: method(:parentname)
  },

  soql_additional_fields: [
    'Campaign.ParentId',
    'Campaign.Parent.Name',
    'CreatedDate'
  ]

}.freeze
