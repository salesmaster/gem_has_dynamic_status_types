# Has Dynamic Status Types

## Installation

Add this line to your application's Gemfile:

    gem 'has_dynamic_status_types', git: 'git@github.com:salesmaster/gem_has_dynamic_status_types.git'

And then execute:

    $ bundle

## Usage

Add definition of status types to model:

    class SomeModel < ActiveRecord::Base
      has_dynamic_status_types :location, :sales
    end

Can now access the defined status types

    model = SomeModel.create(name: 'Thing')
    model.location_status = 'shopfloor'
    model.sales_status = 'sold'

    puts "LStatus: #{model.location_status}"  # LStatus: shopfloor
    puts "SStatus: #{model.sales_status}"  # SStatus: sold

To be able to do a lookup for code to description, you
need to write a class to do so.

    class DynamicStatus::Lookup::SomeModelLocation < DynamicStatus::Lookup

      # returns Hash based on what the #model is
      def lookup_table
        if model.name == 'Thing'
          {
            shopfloor => 'On the shop floor'
          }
        else
          {
            shopfloor => 'On the floor of the shop'
          }
        end
      end
    end

You can now ask the status type for its description

    puts "Location: #{model.location_status.description}"  # Location: On the shop floor

## Migration

The status types are stored in the database against a polymorphic association named
:status_types, to ensure this works you need to do the following migration:

    def change
      create_table :status_types do |t|
        t.integer :status_typeable_id, null: false
        t.string  :status_typeable_type, null: false
        t.string  :status_type, null: false
        t.string  :current_status_code
        t.string  :previous_statuses_codes
        t.timestamps
      end
      add_index :status_types, [:status_typeable_id, :status_typeable_type, :status_type], unique: true, name: 'index_status_types_on_status_typeable'
    end


