require 'aws-sdk'

require_relative '../lib/writer'

def connection_info
  {
      :access_key_id => 'some_aki', :secret_access_key => 'some_sak',
      :region => 'us-east-1',
      :endpoint => 'http://localhost:8000'
  }
end

def table_definition
  {
      table_name: 'items_every_minute',
      key_schema: [{
                       attribute_name: 'id',
                       key_type: 'HASH'
                   }],
      attribute_definitions: [{
                                  attribute_name: 'id',
                                  attribute_type: 'S'
                              }],
      provisioned_throughput: {
          read_capacity_units: 1,
          write_capacity_units: 1
      }
  }
end


describe Writer do

  test_client = Aws::DynamoDB::Client.new(connection_info)

  before(:each) do
    test_client.create_table(table_definition)
  end

  after(:each) do
    test_client.delete_table({table_name: table_definition[:table_name]})
  end

  it 'writes to table' do
    now = Time.new.strftime('%Y%m%dT%H%M%S%z')
    writer = Writer.new(table_definition, connection_info)
    writer.write_item_for_minute(now)

    response = test_client.get_item({
                                        table_name: 'items_every_minute',
                                        key: {
                                            id: now
                                        }
                                    })
    expect(response.item['id']).to eql(now)
  end

end