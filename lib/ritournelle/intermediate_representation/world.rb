class Ritournelle::IntermediateRepresentation::World

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [Hash{}String,Ritournelle::IntermediateRepresentation::Class}]
  attr_reader :clazzez

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methodz

  def initialize
    @clazzez = {}
    @methodz = []
    load_stdlib
  end

  def load_stdlib
    primitive_int_class = Ritournelle::IntermediateRepresentation::Class.new(name: 'int')
    clazzez['int'] = primitive_int_class

    int_class = Ritournelle::IntermediateRepresentation::Class.new(name: 'Int')
    int_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(
        parameters_classes: ['int'], parameters_names: ['value'])
    int_class.constructors << int_constructor

    int_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        declared_name: 'plus',
        implementation_name: 'plus_Int',
        parameters_classes: ['Int'],
        return_class: 'Int')
    int_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        declared_name: 'plus', implementation_name: 'plus_int', parameters_classes: ['int'], return_class: 'Int')
    int_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        declared_name: 'to_float', implementation_name: 'to_float', parameters_classes: [], return_class: 'Float')

    clazzez['Int'] = int_class

    primitive_float_class = Ritournelle::IntermediateRepresentation::Class.new(name: 'float')
    clazzez['float'] = primitive_float_class

    float_class = Ritournelle::IntermediateRepresentation::Class.new(name: 'Float')
    float_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(
        parameters_classes: ['float'], parameters_names: ['value'])
    float_class.constructors << float_constructor

    float_class.methods << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        declared_name: 'plus', implementation_name: 'plus_Float', parameters_classes: ['Float'], return_class: 'Float')
    float_class.methods << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        declared_name: 'plus', implementation_name: 'plus_float', parameters_classes: ['float'], return_class: 'Float')

    clazzez['Float'] = float_class
  end

  def name
    'World'
  end

end