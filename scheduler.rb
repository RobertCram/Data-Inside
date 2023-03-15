# frozen_string_literal: true

require 'rufus-scheduler'
require './playground'
require './file_exchanger'
require './notifier'

scheduler = Rufus::Scheduler.new


scheduler.cron '0 18 * * *' do # uses UCT - starts at 20:00 local time
  file_exchanger = FileExchanger.new
  file_exchanger.sendFiles
rescue Exception => e
  Rails.logger.debug e.message
  puts e.message
  subject = "[Christal Server] #{e.message}"
  body = e.inspect
  Notifier.sendmail(subject. body)
end

scheduler.cron '0 20 * * *' do # uses UCT - starts at 22:00 local time
  execute
rescue Exception => e
  Rails.logger.debug e.message
  puts e.message
  subject = "[DI Server] #{e.message}"
  body = e.inspect
  Notifier.sendmail(subject. body)
end

# scheduler.join
