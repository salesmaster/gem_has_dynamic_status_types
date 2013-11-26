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

    puts "SStatus: #{model.sales_status.description}"  # SStatus: sold

