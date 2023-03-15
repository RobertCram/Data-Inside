# frozen_string_literal: true

require 'uri'
require 'net/http'

# Used for sending a notification
class Notifier

  def self.url url
    @@url = url
  end

  def self.sendmail(subject, body)
    uri = URI(@@url)
    body = { title: subject, text: body }
    headers = { 'Content-Type': 'application/json' }
    response = Net::HTTP.post(uri, body.to_json, headers)
    response.is_a?(Net::HTTPSuccess)
  end
end
