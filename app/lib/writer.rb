require 'aws-sdk'

class Writer

  def initialize(table_definition, config)
    @client = Aws::DynamoDB::Client.new(config)
    @table_definition = table_definition or raise 'Missing table definition'
    setup_table
  end

  def setup_table
    unless table_exists?(table_name)
      @client.create_table(@table_definition)
    end
  end

  def table_exists?(table_name)
    exists = nil
    begin
      response = @client.describe_table(table_name: table_name)
      exists = response[:table].nil? ? false : true
    rescue
      exists = false
    end
    exists
  end

  def table_name
    @table_definition[:table_name] or raise 'Missing table name'
  end

  def write_item_for_minute(minute_str)
    @client.put_item({
                         table_name: table_name,
                         item: {'id': minute_str}
                     })
  end

end