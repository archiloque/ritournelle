require_relative '../base_classes'

class Ritournelle::IntermediateRepresentation::World

  include Ritournelle::BaseClasses

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [Hash{String=>Ritournelle::IntermediateRepresentation::Class}]
  attr_reader :clazzez

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methodz

  def initialize
    @clazzez = {}
    @methodz = []
    load_stdlib
  end

  def load_stdlib
    primitive_int_class = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: SMALL_INT_CLASS_NAME
    )
    clazzez[SMALL_INT_CLASS_NAME] = primitive_int_class

    int_class = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: INT_CLASS_NAME,
        rdoc_name: Ritournelle::Runtime::StdLib::Int.name
    )
    int_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        parent: int_class,
        parameters_classes: [SMALL_INT_CLASS_NAME],
        parameters_names: ['value']
    )
    int_class.constructors << int_constructor

    int_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'plus',
        implementation_name: 'plus_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: INT_CLASS_NAME
    )
    int_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'to_float',
        implementation_name: 'to_float',
        parameters_classes: [],
        return_class: FLOAT_CLASS_NAME
    )

    clazzez[INT_CLASS_NAME] = int_class

    primitive_float_class = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: SMALL_FLOAT_CLASS_NAME
    )
    clazzez[SMALL_FLOAT_CLASS_NAME] = primitive_float_class

    float_class = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: FLOAT_CLASS_NAME,
        rdoc_name: Ritournelle::Runtime::StdLib::Float.name
    )
    float_constructor = Ritournelle::IntermediateRepresentation::Constructor.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        parent: float_class,
        parameters_classes: [SMALL_FLOAT_CLASS_NAME],
        parameters_names: ['value']
    )
    float_class.constructors << float_constructor

    float_class.methodz << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'plus',
        implementation_name: 'plus_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: FLOAT_CLASS_NAME
    )

    clazzez[FLOAT_CLASS_NAME] = float_class

    void_class = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: VOID_CLASS_NAME,
        rdoc_name: SMALL_VOID_CLASS_NAME
    )
    clazzez[VOID_CLASS_NAME] = void_class

    clazzez[WORLD_CLASS_NAME] = self
  end

  def name
    'World'
  end

  # :nocov:
  def to_s
    "World"
  end
  # :nocov:

end