# frozen_string_literal: true

require 'restforce'

# Class used for communication with Salesforce
class Salesforce
  SF_LOGIN_INFO = {
    host: ENV['SF_HOST'] || Chamber['development'][:sf_host],
    api_version: '35.0',
    username: ENV['SF_USERNAME'] || Chamber['development'][:sf_username],
    password: ENV['SF_PASSWORD'] || Chamber['development'][:sf_password],
    security_token: ENV['SF_SECURITY_TOKEN'] || Chamber['development'][:sf_security_token],
    client_id: ENV['SF_CLIENT_ID'] || Chamber['development'][:sf_client_id],
    client_secret: ENV['SF_CLIENT_SECRET'] || Chamber['development'][:sf_client_secret],
    timeout: 300
  }.freeze

  def self.query(query)
    client = create_client
    client.query(query)
  end

  def self.create!(sobject_name, attributes)
    client = create_client
    client.create!(sobject_name, attributes)
  end

  def self.upsert!(sobject, attributes)
    client = create_client
    client.upsert!(sobject.sobject_type, 'Id', attributes.merge({ Id: sobject.Id }))
  end

  def self.create_client
    client = Restforce.new(SF_LOGIN_INFO)
    check_connection(client)
    client
  end

  def self.check_connection(client)
    client.instance_url
  end
end
