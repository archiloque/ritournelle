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

    int_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_Int', ['Int'], 'Int')
    int_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_int', ['int'], 'Int')
    int_class.methods << Ritournelle::IntermediateRepresentation::Method.new('to_float', 'to_float', [], 'Float')

    classes['Int'] = int_class

    primitive_float_class = Ritournelle::IntermediateRepresentation::Class.new('float')
    classes['float'] = primitive_float_class

    float_class = Ritournelle::IntermediateRepresentation::Class.new('Float')
    float_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(['float'], ['value'])
    float_class.constructors << float_constructor

    float_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_Float', ['Float'], 'Float')
    float_class.methods << Ritournelle::IntermediateRepresentation::Method.new('plus', 'plus_float', ['float'], 'Float')

    classes['Float'] = float_class
  end

end