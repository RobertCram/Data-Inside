# frozen_string_literal: true

require 'benchmark'
require 'tiny_tds'
require './notifier'
require './salesforce'
require './sqlserver'
require './uploader'
require './uploads/payments'
require './uploads/contacts'
require './uploads/campaigns'
require './uploads/campaignmembers'
require './uploads/agreements'
require './uploads/accounts'

UPLOADS = [
  PAYMENT_INFO,
  CONTACT_INFO,
  CAMPAIGN_INFO,
  CAMPAIGNMEMBER_INFO,
  AGREEMENT_INFO,
  ACCOUNT_INFO
].freeze

SQL_LOGIN_INFO = {
  host: ENV['SQL_HOST'] || Chamber['development'][:sql_host],
  username: ENV['SQL_USERNAME'] || Chamber['development'][:sql_username],
  password: ENV['SQL_PASSWORD'] || Chamber['development'][:sql_password]
}.freeze

def seconds_to_hms(sec)
  [sec / 3600, sec / 60 % 60, sec % 60].map { |t| t.to_s.rjust(2, '0') }.join(':')
end

def upload(sqlserver, upload_info)
  salesforce = Salesforce.create_client

  elapsed = Benchmark.measure do
    uploader = Uploader.new(salesforce, sqlserver, upload_info)
    uploader.execute
  end

  puts "[#{upload_info[:sql_tablename]}] Verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"
end

def cleanup(sqlserver, exception)
  $info[:stopped] = timestr
  $info[:error] = exception.message
  subject = "[DI Server] #{exception}"
  body = "Het uploaden van de gegevens is mislukt.\n\n#{exception.inspect}"
  Notifier.sendmail(subject, body)
  sqlserver.cleartables(UPLOADS.map { |info| info[:sql_tablename] })
end

def timestr
  Time.now.getlocal('+01:00').strftime('%d-%m-%Y %H:%M') # local time (should add an extra hour for summer time!)
end

def execute
  started = timestr
  $info = { started: started, stopped: '', error: '' }
  puts "Upload gestart: #{started}"

  sqlserver = SQLServer.new(SQL_LOGIN_INFO)
  elapsed = Benchmark.measure { UPLOADS.each { |info| upload sqlserver, info } }

  stopped = timestr
  $info[:stopped] = stopped
  puts "Upload beëindigd: #{stopped}\nTotaal verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"
rescue StandardError => e
  cleanup(sqlserver, e)
  puts "Upoad beëindigd met fouten: #{timestr}\n\n#{e.inspect}\n\n"
end
