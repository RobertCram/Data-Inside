# frozen_string_literal: true

ENV['CHAMBER_KEY'] = ENV['CHAMBER_KEY'].gsub '_', "\n" if ENV.key? 'CHAMBER_KEY'

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

UPLOADS = [
  PAYMENT_INFO,
  CONTACT_INFO,
  CAMPAIGN_INFO,
  CAMPAIGNMEMBER_INFO,
  AGREEMENT_INFO
].freeze

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

def execute
  elapsed = Benchmark.measure do
    UPLOADS.each { |info| upload info }
  end

  puts "Totaal verstreken tijd: #{seconds_to_hms(elapsed.real.to_i)}\n\n"
end
