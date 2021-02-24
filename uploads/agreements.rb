# frozen_string_literal: true

AGREEMENT_INFO = {

  sf_tablename: 'soco__Agreement__c',

  predicate: "Id != null LIMIT #{Uploader::SOQL_RECORD_LIMIT}",

  sql_tablename: 'ImportSfAgreement',

  mapping: {
    # AgreementMigrationIDc: ?
    Id: 'Id',
    Name: 'Name',
    DonationContractc: 'Donatie_Contract__c', # wordt niet gebruikt
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
    LeverancierC: 'soco__originating_Campaign__r.Leverancier__c'
  }

}.freeze
