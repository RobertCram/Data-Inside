# frozen_string_literal: true

def parentname(_, values, _)
  value = values['name']
  parent_value = values['parent.name']
  Uploader.quotedstring(values['parentid'].nil? ? value : parent_value)
end

# def volgnummer(_, values, _)
#   value = Uploader.integer_to_string(values['identificatie_nummer__c'])
#   parent_value = Uploader.integer_to_string(values['parent.identificatie_nummer__c'])
#   values['parentid'].nil? ? value : parent_value
# end

# def actualcosts(_, values, _)
#   value = Uploader.number_to_string(values['actualcost'])
#   parent_value = Uploader.number_to_string(values['parent.actualcost'])
#   values['parentid'].nil? ? value : parent_value
# end

# def targetc(_, values, _)
#   value = Uploader.number_to_string(values['expectedrevenue'])
#   parent_value = Uploader.number_to_string(values['parent.expectedrevenue'])
#   values['parentid'].nil? ? value : parent_value
# end

CAMPAIGN_INFO = {

  sf_tablename: 'Campaign',

  predicate: <<~SOQL,
    Id != Null LIMIT #{Uploader::SOQL_RECORD_LIMIT}
  SOQL

  sql_tablename: 'ImportSfCampaign',

  mapping: {
    Versie: 'Uiting__c',
    VersieId: 'Id',
    # IsActive: 'IsActive',  wordt niet gebruikt
    EndDate: 'EndDate',
    StartDate: 'StartDate',
    CampagneKanaal: 'Campagnekanaal__c',
    CampagneDoel: 'Campagnedoel__c',
    # socoNumberofPaymentsc:
    # socoAmountOfPaymentsc:
    ParentId: 'ParentId',
    ActualCost: 'ActualCost', # nog niet ingevuld
    TargetC: 'ExpectedRevenue', # nog niet ingevuld
    Incentive: 'Gevraagd_bedrag__c', # nog niet ingevuld
    Volgnummer: 'Identificatie_nummer__c', # nog niet ingevuld
    Parentname: 'Name',
    SocoDestinationC: 'soco__Destination__r.Type__c'
  },

  converters: {
    ActualCost: Uploader.method(:number_to_string),
    TargetC: Uploader.method(:number_to_string),
    Incentive: Uploader.method(:number_to_string),
    Volgnummer: Uploader.method(:integer_to_string),
    Parentname: method(:parentname)
  },

  soql_additional_fields: [
    'Parent.Name'
    # 'Parent.Identificatie_Nummer__c',
    # 'Parent.ActualCost',
    # 'Parent.ExpectedRevenue'
  ]

}.freeze
