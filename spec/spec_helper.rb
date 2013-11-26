
require "minitest/autorun"
require "has_dynamic_status_types"
require "timecop"

# -- below we setup my test AR structure

class DynamicStatus::Lookup::PenLocation < DynamicStatus::Lookup
  def lookup_table
    {}
  end
end
class DynamicStatus::Lookup::PenInk < DynamicStatus::Lookup
  def lookup_table
    {
      'empty' => 'No ink remains',
      'dry' => 'The ink has dried',
    }
  end
end

class Pen < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.create_table :pens do |t|
  t.string :type
  t.float :colour
  t.timestamps
end
ActiveRecord::Migration.create_table :status_types do |t|
  t.integer :status_typeable_id,   null: false
  t.string  :status_typeable_type, null: false
  t.string  :status_type, null: false
  t.string  :current_status_code
  t.string  :previous_statuses_codes
  t.timestamps
end

Pen.create(type: 'fountain', colour: 'blue')
Pen.create(type: 'biro',     colour: 'green')
