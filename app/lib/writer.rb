require 'aws-sdk'

class Writer

  def initialize(table_definition, config)
    @client = Aws::DynamoDB::Client.new(config)
    @table_name = table_definition[:table_name] or raise 'Missing table name'
  end

  def write_item_for_minute(minute_str)
    @client.put_item({
                         table_name: @table_name,
                         item: {'id': minute_str}
                     })

  end

end