require 'spec_helper'

describe HasDynamicStatusTypes::Association do

  it "should set its table name" do
    HasDynamicStatusTypes::Association.table_name.must_equal('status_types')
  end

  it "belongs to status_typeable" do
    belongs_tos = HasDynamicStatusTypes::Association.reflect_on_all_associations(:belongs_to)
    belongs_tos.must_be_kind_of(Array)

    poly_bt = belongs_tos.find { |bt| bt.name == :status_typeable }
    poly_bt.wont_be_nil

    poly_bt.options.must_include(:polymorphic)
    poly_bt.options[:polymorphic].must_equal(true)
  end

  it "has accessible attributes" do
    [:status_type, :current_status_code].each do |attr|
      HasDynamicStatusTypes::Association.accessible_attributes.must_include attr
    end
  end

  it "stores history as YAML when saving" do
    class Pen
      # this is a dup of whats in '#has_dynamic_status_types' .. I only want to check we have a #history method that works
      has_many :status_types, as: 'status_typeable', class_name: HasDynamicStatusTypes::Association, autosave: true
    end
    pen = Pen.create(type: 'Ball Point', colour: 'purple')
    status_type = pen.status_types.build(status_type: 'ink', current_status_code: 'xyz')

    status_type.previous_statuses_codes.must_be_nil
    status_type.save
    status_type.previous_statuses_codes.must_match /\:code\: xyz\n  \:when\: \!ruby\/object\:DateTime/
  end

  it "can provide a list of history" do

    class Pen
      # this is a dup of whats in '#has_dynamic_status_types' .. I only want to check we have a #history method that works
      has_many :status_types, as: 'status_typeable', class_name: HasDynamicStatusTypes::Association, autosave: true
    end

    Timecop.freeze("2013-09-30 06:22:59") do
      pen = Pen.create(type: 'Ball Point', colour: 'purple')
      status_type = pen.status_types.create(status_type: 'ink', current_status_code: 'abc')
      status_type.history.must_equal [{:code=>"abc", when: DateTime.now}]
    end

  end

end
