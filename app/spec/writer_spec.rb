require 'aws-sdk'

require_relative '../lib/writer'
require_relative '../lib/definitions'

def local_connection_info
  {
      :access_key_id => 'some_aki', :secret_access_key => 'some_sak',
      :endpoint => 'http://localhost:8000'
  }
end


describe Writer do

  test_client = Aws::DynamoDB::Client.new(local_connection_info)
  table_definition = Definitions::table_definition.dup

  before(:each) do
    test_client.create_table(table_definition)
  end

  after(:each) do
    test_client.delete_table({table_name: table_definition[:table_name]})
  end

  it 'writes to table' do
    now = Definitions::get_time_string
    writer = Writer.new(table_definition, local_connection_info)
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