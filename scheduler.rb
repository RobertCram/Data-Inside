# frozen_string_literal: true

require 'rufus-scheduler'
require './playground'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 20 * * *' do # uses UCT - starts at 22:00 local time
  execute
end

scheduler.join
