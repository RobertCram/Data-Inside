# frozen_string_literal: true

require 'benchmark'

require 'chamber'
require 'tiny_tds'
require './salesforce'
require './uploader'
require './uploads/payments'
require './uploads/contacts'
require './uploads/campaigns'
require './uploads/campaignmembers'
require './uploads/agreements'

def connect_to_sqlserver
  settings = Chamber['development']
  client = TinyTds::Client.new username: settings[:username], password: settings[:password], host: settings[:host]

  puts "Connecting to Data Inside SQL Server - Proof of Concept\n\n"

  puts "Connection active = #{client.active?}\n\n"
  puts "TABLES:\n"
  puts "=======\n"

  result = client.execute('SELECT * FROM INFORMATION_SCHEMA.TABLES')

  table_names = []
  result.each do |row|
    table_names << row['TABLE_NAME']
  end

  puts(table_names.select! { |name| name.start_with? 'Import' })

  table_names.each do |name|
    result = client.execute("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'#{name}'")
    puts "\n\nFIELDS (for #{name})\n"
    puts '======'
    result.each do |row|
      puts row['COLUMN_NAME'].inspect
    end
  end
end

def connect_to_salesforce
  client = Salesforce.create_client
  puts Salesforce.check_connection(client)

  results = select_payments
  puts results.length
  # select_payments.each do |record|
  #   puts record.attrs['Id']
  # end
end

def seconds_to_hms(sec)
  [sec / 3600, sec / 60 % 60, sec % 60].map { |t| t.to_s.rjust(2, '0') }.join(':')
end

def upload(upload_info)
  salesforce = Salesforce.create_client

  settings = Chamber['development']
  sqlserver = TinyTds::Client.new username: settings[:username], password: settings[:password], host: settings[:host]

  elapsed = Benchmark.measure do
    uploader = Uploader.new(salesforce, sqlserver, upload_info)
    uploader.execute
  end

  puts "[#{upload_info[:sql_tablename]}] Verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"
end

uploads = [
  # PAYMENT_INFO,
  #CONTACT_INFO,
  #CAMPAIGN_INFO,
  CAMPAIGNMEMBER_INFO,
  #AGREEMENT_INFO
]

elapsed = Benchmark.measure do
  uploads.each { |info| upload info }
end

puts "Totaal verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"
