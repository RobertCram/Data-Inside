# frozen_string_literal: true

require 'tiny_tds'

# Class used for communication with SQL Server
class SQLServer
  def initialize(host:, username:, password:)
    @client = TinyTds::Client.new(host: host, username: username, password: password)
  end

  def execute(sql)
    @client.execute(sql)
  end

  def cleartable(tablename)
    result = @client.execute("TRUNCATE TABLE #{tablename}")
    result.do
  end

  def cleartables(tables)
    tables.each do |table|
      cleartable(table)
    end
  end
end
