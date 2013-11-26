=begin

Class that holds a Dynamic status code, it acts very simlar to 
a normal code/string, but has #description that uses a instanciats
a class (passing in the model) to lookup what the description of 
the code is.

=end

require 'delegate'

class DynamicStatus < SimpleDelegator
  attr_accessor :model, :type, :code
  def initialize(status_code, model, status_type)
    super(status_code) # delegate to the code.

    @code, @model, @type = status_code, model, status_type

  end

  def description
    looker_upper.description_for( code )
  end

  private

  def looker_upper
    # instanciat object that knows how to build the correct
    # lookup table for this status type
    @looker_upper ||= lookup_class.new(model)
  end

  def lookup_class
    klass = model.class.name + type.to_s.classify 
    begin
      lookup_class = Lookup.const_get(klass)
    rescue NameError => e
      warn "You should define DynamicStatus::Lookup::#{klass} and implement #lookup_table"
      lookup_class = Lookup
    end
    lookup_class
  end

end
