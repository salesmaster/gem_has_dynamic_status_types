require 'spec_helper'

describe DynamicStatus::Lookup do

  it "uses #lookup like a hash table of code => description " do

    model = Pen.create(type: 'Ball Point', colour: 'purple')
    @lookup = DynamicStatus::Lookup.new(model)

    def @lookup.lookup_table # stub method
      return { 'abc' => 'Test Desc', '123' => 'test 2' }
    end

    @lookup.description_for('abc').must_equal 'Test Desc'
    @lookup.description_for('123').must_equal 'test 2'
    @lookup.description_for('xyz').must_be_nil
  end

end
