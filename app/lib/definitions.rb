module Definitions

  def self.table_definition
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

  def self.get_time_string
    Time.new.strftime('%Y%m%dT%H%M%S%z')
  end

end