class Ritournelle::IntermediateRepresentation::World

  # @return [Array]
  attr_reader :statements

  # @return [Array<Ritournelle::IntermediateRepresentation::Class>]
  attr_reader :classes

  def initialize
    @statements = []
    @classes = []
    load_stdlib
  end

  def load_stdlib
    primitive_int_class = Ritournelle::IntermediateRepresentation::Class.new('int')
    classes << primitive_int_class
    int_class = Ritournelle::IntermediateRepresentation::Class.new('Int')
    int_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(['int'], ['value'])
    int_class.constructors << int_constructor
    classes << int_class
  end

end