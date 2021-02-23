# frozen_string_literal: true

PAYMENT_INFO = {

  sf_tablename: 'soco__Payment__c',

  predicate: <<~SOQL,
    FW__c = true AND soco__Collection_Date__c >= #{Uploader::CUTOFF_DATE} LIMIT #{Uploader::SOQL_RECORD_LIMIT}
  SOQL

  sql_tablename: 'ImportSfPayment',

  mapping: {
    Id: 'Id',
    cpmContactc: 'soco__Contact__c',
    copaAgreementc: 'soco__Agreement__c',
    cpmCollectionDatec: 'soco__Collection_Date__c',
    cpmAmountc: 'soco__Amount__c',
    cpmPaymentMethodc: 'soco__Payment_Method__c',
    cpmOriginatingCampaignc: 'soco__Originating_Campaign__c',
    copaDestinationc: 'soco__Destination_lookup__r.Type__c',
    SoconInstallmentc: 'soco__n_Installment__c'
  }

}.freeze
