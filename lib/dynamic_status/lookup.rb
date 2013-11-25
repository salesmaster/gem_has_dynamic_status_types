class DynamicStatus::Lookup

  attr_reader :model
  attr_accessor :table

  def initialize(model)
    @model = model
    @table = nil # hash table used to lookup codes within
  end

  def description_for(code)
    table[code]
  end

  def table
    @table ||= lookup_table
  end

  def lookup_table
    raise NotImplementedError
  end

  # You can write a real lookup class like so:
  class VehicleFleet < DynamicStatus::Lookup
    def lookup_table
      # some logic goes here to determin how to get the
      # code/name lookup
      {
        'abc' => 'Alpha Bravo Charlie',
        'cba' => 'Charlie Bravo Alpha'
      }
    end
  end

end
