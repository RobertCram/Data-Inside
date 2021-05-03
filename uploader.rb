# frozen_string_literal: true

# Base class to handle uploads
class Uploader
  CUTOFF_DATE = (Date.today - 182).strftime('%Y-%m-%d')
  SOQL_RECORD_LIMIT = 10_000_000
  INSERTS_PER_CALL = 1000

  def self.escape(value)
    !value.nil? && value.is_a?(String) ? value.gsub("\'", "\'\'") : value
  end

  def self.quotedstring(value)
    "'#{escape(value)}'"
  end

  def self.datetime_to_date(value, _ = nil, _ = nil)
    quotedstring(value[0..9])
  end

  def self.number_to_string(value, _ = nil, _ = nil)
    quotedstring(value.to_s)
  end

  def self.integer_to_string(value, _ = nil, _ = nil)
    quotedstring(value.to_i.to_s)
  end

  def initialize(salesforce, sqlserver, upload_info)
    @selected = 0
    @inserted = 0
    @salesforce = salesforce
    @sqlserver = sqlserver
    @info = upload_info
    @mapping = @info[:mapping].transform_keys(&:downcase).transform_values(&:downcase)
    @converters = @info[:converters].transform_keys(&:downcase) unless @info[:converters].nil?
    @soqlfields = @mapping.values
    @soqlfields += @info[:soql_additional_fields].map(&:downcase) unless @info[:soql_additional_fields].nil?
  end

  def execute
    cleartable @info[:sql_tablename]
    puts "[#{@info[:sql_tablename]}] Getting data..."
    data = selectdata
    return if data.nil?

    puts "[#{@info[:sql_tablename]}] Inserting #{@selected} records..."
    insertdata(data)
    puts "[#{@info[:sql_tablename]}] Inserted #{@inserted} records."
  end

  private

  def cleartable(tablename)
    result = @sqlserver.execute("TRUNCATE TABLE #{tablename}")
    result.do
  end

  def selectdata
    soqlstring = @soqlfields.join(',')
    query = "SELECT #{soqlstring} FROM #{@info[:sf_tablename]} WHERE #{@info[:predicate]}"
    data = @salesforce.query(query)
    @selected = data.length
    data
  rescue Faraday::TimeoutError
    puts "[#{@info[:sql_tablename]}] Timeout error - try again later."
    nil
  end

  def insertdata(data)
    data.each_slice(INSERTS_PER_CALL) do |records|
      soqlvalues = records.map { |record| record_to_soql_values(record) }
      sqlvalues = soqlvalues_to_sqlvalues(soqlvalues)
      sql = getsql(sqlvalues.join(",\n"))
      # puts sql
      executesql(sql)
    end
  end

  def record_to_soql_values(record)
    @soqlfields.map { |field| Hash[field, getsoqlvalue(record, field)] }.inject(:merge)
  end

  def soqlvalues_to_sqlvalues(soqlvalues)
    soqlvalues.map do |values|
      "(#{@mapping.map { |sql, soql| getsqlvalue(values, sql, soql) }.join(',')})"
    end
  end

  def getsoqlvalue(record, field)
    return nil if record.nil?

    return record.attrs.transform_keys(&:downcase)[field] unless field.include? '.'

    p = field.index '.'
    getsoqlvalue(record.transform_keys(&:downcase)[field[0..p - 1]], field[p + 1..])
  end

  def getsqlvalue(soqlvalues, sqlfield, soqlfield)
    value = soqlvalues[soqlfield]
    c = @converters
    return self.class.quotedstring(value) if c.nil? || !c.include?(sqlfield)

    c[sqlfield].call(value, soqlvalues, sqlfield)
  end

  def getsql(values)
    sqlfields = @mapping.keys.join(',')
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
