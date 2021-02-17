# frozen_string_literal: true

require 'chamber'
require 'tiny_tds'

settings = Chamber['development']
client = TinyTds::Client.new username: settings[:username], password: settings[:password], host: settings[:host]

puts "Connecting to Data Inside SQ: Server - Proof of Concept\n\n"

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
