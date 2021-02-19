# frozen_string_literal: true

# Base class to handle uploads
class Uploader
  CUTOFF_DATE = '2018-02-17'
  SOQL_RECORD_LIMIT = 10_000_000
  INSERTS_PER_CALL = 1000

  def self.datetime_to_date(value)
    value[0..9]
  end

  def initialize(salesforce, sqlserver, upload_info)
    @selected = 0
    @inserted = 0
    @salesforce = salesforce
    @sqlserver = sqlserver
    @info = upload_info
  end

  def execute
    cleartable
    puts "[#{@info[:sql_tablename]}] Getting data..."
    data = selectdata
    return if data.nil?

    puts "[#{@info[:sql_tablename]}] Inserting #{@selected} records..."
    insertdata(data)
    puts "[#{@info[:sql_tablename]}] Inserted #{@inserted} records."
  end

  private

  def cleartable
    result = @sqlserver.execute("TRUNCATE TABLE #{@info[:sql_tablename]}")
    result.do
  end

  def selectdata
    soqlfields = @info[:mapping].values.join(',')
    query = "SELECT #{soqlfields} FROM #{@info[:sf_tablename]} WHERE #{@info[:predicate]}"
    data = @salesforce.query(query)
    @selected = data.length
    data
  rescue Faraday::TimeoutError
    puts "[#{@info[:sql_tablename]}] Timeout error - try again later."
    nil
  end

  def insertdata_old(data)
    data.each_slice(INSERTS_PER_CALL) do |records|
      soqlfields = @info[:mapping].values
      values = records.map { |record| "(#{soqlfields.map { |field| "'#{get(record, field)}'" }.join(',')})" }
      values = convert(values).join(",\n")
      sql = getsql(values)
      executesql(sql)
    end
  end

  def insertdata(data)
    data.each_slice(INSERTS_PER_CALL) do |records|
      soqlfields = @info[:mapping].values
      value_arrays = records.map { |record| soqlfields.map { |field| get(record, field) } }
      value_arrays = value_arrays.map { |value_array| convert(value_array) }
      value_strings = value_arrays.map { |value_array| "(#{value_array.map { |value| "'#{value}'" }.join(',')})" }
      values = value_strings.join(",\n")
      sql = getsql(values)
      executesql(sql)
    end
  end

  def convert(values)
    c = @info[:converters]
    return values if c.nil?

    m = @info[:mapping]
    values.each_with_index.map { |value, i| c.key?(m.keys[i]) ? c[m.keys[i]].call(value) : value }
  end

  def get(record, field)
    return nil if record.nil?

    return record.attrs[field] unless field.include? '.'

    p = field.index '.'
    puts record.inspect if record[field[0..p - 1]].nil?
    get(record[field[0..p - 1]], field[p + 1..])
  end

  def getsql(values)
    sqlfields = @info[:mapping].keys.join(',')
    <<~SQL
      INSERT INTO #{@info[:sql_tablename]}
      (#{sqlfields})
      VALUES
      #{values}
    SQL
  end

  def executesql(sql)
    result = @sqlserver.execute(sql)
    @inserted += result.do
  end
end
