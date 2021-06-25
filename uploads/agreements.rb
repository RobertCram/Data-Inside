# frozen_string_literal: true

AGREEMENT_INFO = {

  sf_tablename: 'soco__Agreement__c',

  predicate: <<~SOQL,
    (soco__End_Date__c = null OR soco__End_Date__c >= #{Uploader::START_DATE}) LIMIT #{Uploader::SOQL_RECORD_LIMIT}
  SOQL

  sql_tablename: 'ImportSfAgreement',

  mapping: {
    # AgreementMigrationIDc: ?
    Id: 'Id',
    Name: 'Name',
    # DonationContractc: ? # wordt niet gebruikt
    # socoAccountc: ? # wordt niet gebruikt
    socoAmountc: 'soco__Amount__c',
    socoContactc: 'soco__Contact__c',
    socoEndDatec: 'soco__End_Date__c',
    socoOriginatingCampaignc: 'soco__originating_Campaign__c',
    socoStartDatec: 'soco__Start_Date__c',
    socoFrequencyc: 'soco__Frequency__c',
    socoActivec: 'soco__Active__c',
    # Reasonforcancellationc: ? # staat al in OpzegredenC
    socoPaymentMethodc: 'soco__Payment_method__c', # altijd dezelfde
    # copaPaymentMethodc: ?
    # socoStatusReasonC: ? # gebruiken we niet
    # socoStatusC: ? # gebruiken we niet (staat al in soco__Active__c)
    OpzegredenC: 'Redenen_beeindiging__c',
    # IsAkte: ? # Donatie_Contract
    socoDestinationC: 'soco__Destination_lookup__r.Type__c',
    LeverancierC: 'soco__originating_Campaign__r.Leverancier__c',
    Werverscode: 'Werver_Id__c',
    Nagebeld: 'Nagebeld__c'
  }

}.freeze
