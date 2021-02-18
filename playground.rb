# frozen_string_literal: true

require 'benchmark'

require 'chamber'
require 'tiny_tds'
require './salesforce'
require './contacts'
require './payments'

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

# def seconds_to_hms(sec)
#   '%02d:%02d:%02d' % [sec / 3600, sec / 60 % 60, sec % 60]
# end

salesforce = Salesforce.create_client

settings = Chamber['development']
sqlserver = TinyTds::Client.new username: settings[:username], password: settings[:password], host: settings[:host]

elapsed = Benchmark.measure do
  payments = Payments.new(salesforce, sqlserver)
  payments.execute
end

puts "Verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}"
