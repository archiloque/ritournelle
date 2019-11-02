class Ritournelle::IntermediateRepresentation::World

  # @return [Array]
  attr_reader :statements

  # @return [Hash{}String,Ritournelle::IntermediateRepresentation::Class}]
  attr_reader :classes

  def initialize
    @statements = []
    @classes = {}
    load_stdlib
  end

  def load_stdlib
    primitive_int_class = Ritournelle::IntermediateRepresentation::Class.new('int')
    classes['int'] = primitive_int_class

    int_class = Ritournelle::IntermediateRepresentation::Class.new('Int')
    int_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(['int'], ['value'])
    int_class.constructors << int_constructor

    int_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_Int', ['Int'])
    int_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_int', ['int'])

    classes['Int'] = int_class
  end

end