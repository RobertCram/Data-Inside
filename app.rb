# frozen_string_literal: true

ENV['CHAMBER_KEY'] = ENV['CHAMBER_KEY'].gsub '_', "\n" if ENV.key? 'CHAMBER_KEY'

require 'chamber'
require 'sinatra'
require './scheduler'
require './notifier'

Notifier.url(ENV['NOTIFICATION_URL'] || Chamber['development'][:notification_url])

$info = {
  started: 'not started yet',
  stopped: '',
  error: ''
}

$christal_info = {
  started: 'not started yet',
  stopped: '',
  error: '' 
}

def running_rufus
  return null unless defined?(Rufus::Scheduler)

  ObjectSpace.each_object do |o|
    next unless o.is_a?(Rufus::Scheduler)
    return null unless o.up?

    return null unless o.thread.alive?

    return o
  end

  null
end

get '/' do
  erb :index
end

get '/rufus' do
  rufus = running_rufus
  html = '<h1>Data Inside Server</h1><br><br>'
  html += if rufus
            "RUFUS RUNNING<br><br>#{rufus.cron_jobs[0].inspect}"
          else
            'RUFUS NOT RUNNING'
          end

  "#{html}'<a></a>'"
end