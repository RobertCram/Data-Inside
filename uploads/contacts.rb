# frozen_string_literal: true

require './uploader'

CONTACT_INFO = {

  sf_tablename: 'Contact',

  predicate: <<~SOQL,
    AccountId != null LIMIT #{Uploader::SOQL_RECORD_LIMIT}
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
    AccountType: 'Account.Type',
    Contactnummer: 'Contact_nummer__c',
    NalatenC: 'Nalaten__c',
    EenKeerPerJaarAcceptgiroC: 'X1_keer_per_jaar_acceptgiro__c',
    PersoonlijkeBenaderingMajorDonorC: 'Persoonlijke_benadering_Major_Donor__c',
    PersoonlijkeBenaderingNalatenC: 'Persoonlijke_benadering_Nalaten__c',
    PersoonlijkeBenaderingVMFenBedrijvenC: 'Persoonlijke_benadering_VMF_en_bedrijven__c',
    NietBedankenC: 'Niet_bedanken__c',
    EinddatumAVGbewaartermijnC: 'Einddatum_AVG_bewaartermijn__c',
    Abonnee_kwartaalmagazine__c: 'Abonnee_kwartaalmagazine__c',
    PeriodiekeSchenkingsovereenkomstC: 'Notariele_schenker__c'
  },

  converters: {
    Createddate: Uploader.method(:datetime_to_date)
  }

}.freeze
