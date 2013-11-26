require 'spec_helper'

describe DynamicStatus do

  before do
    code = 'empty'
    model = Pen.create(type: 'Ball Point', colour: 'purple')
    type = 'ink'
    @ds = DynamicStatus.new(code, model, type)
  end

  it "can lookup a description" do
    @ds.description.must_equal 'No ink remains'
  end

end
