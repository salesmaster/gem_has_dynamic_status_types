=begin

Base class to be used by DynamicStatus to lookup descriptions from codes
using a passed in model as a reference.
(original idea is to be able to use different status codes for different vehicles)

=end

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

end
