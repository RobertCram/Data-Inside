# frozen_string_literal: true

require 'rufus-scheduler'
require './playground'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 22 * * *' do
  execute
end

scheduler.join
