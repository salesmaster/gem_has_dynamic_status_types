
class DynamicStatus
  attr_accessor :model, :type, :code, :looker_upper
  def initialize(model, type, code)
    @model, @type, @code = model, type, code

    # instanciate object that knows how to build the correct
    # lookup table for this status type
    klass = model.class.name + type.to_s.classify
    begin
      lookup_class = Lookup.const_get(klass)
    rescue NameError => e
      warn "You should define DynamicStatus::Lookup::#{klass} and implement #lookup_table"
      lookup_class = Lookup
    end
    @looker_upper = lookup_class.new(model)

  end

  def ==(compared_to)
    code == compared_to
  end

  def to_s
    code
  end

  def description
    looker_upper.description_for( code )
  end

end
