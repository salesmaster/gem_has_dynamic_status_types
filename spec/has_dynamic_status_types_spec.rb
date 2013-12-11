require 'spec_helper'

describe HasDynamicStatusTypes do

  describe "correct usage" do
    before do
      class ::Pen
        has_dynamic_status_types :location, :ink
      end
    end

    it "defines a has_many association" do
      has_manys = Pen.reflect_on_all_associations(:has_many)
      has_manys.must_be_kind_of Array

      ass = has_manys.find { |hm| hm.name == :status_types }
      ass.wont_be_nil

      ass.options.must_include(:autosave)
      ass.options[:autosave].must_equal(true)
    end

    it "defines a setter and getter for each state" do
      pen = Pen.create(type: 'Felt Tip', colour: 'red')
      (pen.location_status = 'in_draw').must_equal 'in_draw'
      (pen.ink_status = 'dry').must_equal 'dry'

      pen.location_status.must_equal 'in_draw'
      pen.ink_status.must_equal 'dry'
    end

    it "defines a method to get a history of a state" do
      pen = Pen.create(type: 'Marker', colour: 'black')

      (pen.location_status = 'in_draw').must_equal 'in_draw'
      pen.save

      (pen.location_status = 'in_hand').must_equal 'in_hand'
      pen.save

      (pen.location_status = 'behind_ear').must_equal 'behind_ear'
      pen.save

      # ensure we dont save history if we did not change since the prev status.
      (pen.location_status = 'behind_ear').must_equal 'behind_ear'
      pen.save

      pen.hist_location_status.must_be_kind_of(Array)
      pen.hist_location_status.must_equal(["in_draw","in_hand","behind_ear"])
    end

    it "allows a user to get a the description of a code" do
      pen = Pen.create(type: 'Fine Point', colour: 'yellow')
      (pen.ink_status = 'empty').must_equal 'empty'
      pen.ink_status.description.must_equal 'No ink remains'
    end

    it "can be updated via update_attributes" do
      pen = Pen.create(type: 'Felt Tip', colour: 'red')
      pen.update_attributes(location_status: 'in_pants', ink_status: 'empty')
      pen.location_status.must_equal 'in_pants'
      pen.ink_status.must_equal 'empty'
      pen.ink_status.description.must_equal 'No ink remains'
    end

    it "can destorys the status with the model" do
      pen = Pen.create(type: 'Felt Tip', colour: 'red', location_status: 'in_pants')
      id = pen.id
      pen.destroy

      pen2 = Pen.new(type: 'Felt Tip', colour: 'red')
      pen2.id = id
      pen2.save!

      pen2 = Pen.find id
      pen2.location_status.wont_equal 'in_pants'
    end

  end
end
