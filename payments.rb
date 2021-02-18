# frozen_string_literal: true

# Class to handle payment uploads
class Payments
  TABLENAME = 'ImportSfPayment'

  INSERTS_PER_CALL = 1000

  MAPPING = {
    Id: 'Id',
    cpmContactc: 'soco__Contact__c',
    copaAgreementc: 'soco__Agreement__c',
    cpmCollectionDatec: 'soco__Collection_Date__c',
    cpmAmountc: 'soco__Amount__c',
    cpmPaymentMethodc: 'soco__Payment_Method__c',
    cpmOriginatingCampaignc: 'soco__Originating_Campaign__c',
    copaDestinationc: 'soco__Destination_lookup__r.Type__c',
    SoconInstallmentc: 'soco__n_Installment__c'
  }.freeze

  SOQL = <<~SOQL
    SELECT
      Id,
      soco__Contact__c,
      soco__Agreement__c,
      soco__Collection_Date__c,
      soco__Amount__c,
      soco__Payment_Method__c,
      soco__Originating_Campaign__c,
      soco__Destination_lookup__r.Type__c,
      soco__n_Installment__c
    FROM soco__Payment__c WHERE FW__c = true AND soco__Collection_Date__c >= 2018-02-17
  SOQL

  SOQLFIELDS = MAPPING.values
  SQLFIELDS = MAPPING.keys.join(',')

  def initialize(salesforce, sqlserver)
    @selected = 0
    @inserted = 0
    @salesforce = salesforce
    @sqlserver = sqlserver
  end

  def execute
    cleartable
    data = selectdata
    insertdata(data)
  end

  private

  def cleartable
    result = @sqlserver.execute("TRUNCATE TABLE #{TABLENAME}")
    result.do
  end

  def selectdata
    @salesforce.query(SOQL)
  rescue Faraday::TimeoutError => e
    puts e.inspect
    exit
  end

  def insertdata(data)
    @selected = data.length
    data.each_slice(INSERTS_PER_CALL) do |records|
      values = records.map { |record| "(#{SOQLFIELDS.map { |field| "'#{get(record, field)}'" }.join(',')})" }
      values = values.join(",\n")
      sql = getsql(values)
      executesql(sql)
    end
  end

  def get(record, field)
    return record.attrs[field] unless field.include? '.'

    p = field.index '.'
    get(record[field[0..p - 1]], field[p + 1..])
  end

  def getsql(values)
    <<~SQL
      INSERT INTO #{TABLENAME}
      (#{SQLFIELDS})
      VALUES
      #{values}
    SQL
  end

  def executesql(sql)
    result = @sqlserver.execute(sql)
    @inserted += result.do
    puts "Selected: #{@selected}, Inserted: #{@inserted}"
  end
end
