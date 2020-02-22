require_relative '../base_classes'

class Ritournelle::IntermediateRepresentation::World

  include Ritournelle::BaseClasses

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [Hash{String=>Ritournelle::IntermediateRepresentation::ClassDeclaration}]
  attr_reader :classes_declarations

  # @return [Hash{String=>Ritournelle::IntermediateRepresentation::InterfaceDeclaration}]
  attr_reader :interfaces_declarations

  # @return [Array<Ritournelle::IntermediateRepresentation::MethodDeclaration>]
  attr_reader :methods_declarations

  alias_method :callables_declarations, :methods_declarations

  def initialize
    @classes_declarations = {}
    @interfaces_declarations = {}
    @methods_declarations = []
    @methods_indexes = {}
    load_stdlib
  end

  # @param [String] declared_name
  # @param [Array<String>] parameters_classes
  # @return [Integer]
  def method_index(declared_name:, parameters_classes:)
    method_key = "#{declared_name}(#{parameters_classes.join(',')})"
    if @methods_indexes.key?(method_key)
      @methods_indexes[method_key]
    else
      index = @methods_indexes.length
      @methods_indexes[method_key] = index
      index
    end
  end

  def load_stdlib
    primitive_boolean_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: BOOLEAN_CLASS_NAME
    )
    classes_declarations[BOOLEAN_CLASS_NAME] = primitive_boolean_class

    boolean_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/boolermediate_representation/world.rb',
        line_index: -1,
        name: BOOLEAN_CLASS_NAME,
        rdoc_name: Ritournelle::Runtime::StdLib::Bool.name
    )
    boolean_constructor = Ritournelle::IntermediateRepresentation::ConstructorDeclaration.new(
        file_path: 'lib/ritournelle/boolermediate_representation/world.rb',
        line_index: -1,
        parent: boolean_class,
        parameters_classes: [SMALL_BOOLEAN_CLASS_NAME],
        parameters_names: ['value']
    )
    boolean_class.constructors << boolean_constructor
    classes_declarations[BOOLEAN_CLASS_NAME] = boolean_class

    primitive_int_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: SMALL_INT_CLASS_NAME
    )
    classes_declarations[SMALL_INT_CLASS_NAME] = primitive_int_class

    int_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: INT_CLASS_NAME,
        rdoc_name: Ritournelle::Runtime::StdLib::Int.name
    )
    int_constructor = Ritournelle::IntermediateRepresentation::ConstructorDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        parent: int_class,
        parameters_classes: [SMALL_INT_CLASS_NAME],
        parameters_names: ['value']
    )
    int_class.constructors << int_constructor

    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'plus',
        implementation_name: 'plus_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: INT_CLASS_NAME
    )
    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'less_than',
        implementation_name: 'less_than_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'less_than_or_equal_to',
        implementation_name: 'less_than_or_equal_to_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'more_than',
        implementation_name: 'more_than_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'more_than_or_equal_to',
        implementation_name: 'more_than_or_equal_to_Int',
        parameters_classes: [INT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    int_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'to_float',
        implementation_name: 'to_float',
        parameters_classes: [],
        return_class: FLOAT_CLASS_NAME
    )

    classes_declarations[INT_CLASS_NAME] = int_class

    primitive_float_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: SMALL_FLOAT_CLASS_NAME
    )
    classes_declarations[SMALL_FLOAT_CLASS_NAME] = primitive_float_class

    float_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: FLOAT_CLASS_NAME,
        rdoc_name: Ritournelle::Runtime::StdLib::Float.name
    )
    float_constructor = Ritournelle::IntermediateRepresentation::ConstructorDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        parent: float_class,
        parameters_classes: [SMALL_FLOAT_CLASS_NAME],
        parameters_names: ['value']
    )
    float_class.constructors << float_constructor

    float_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'plus',
        implementation_name: 'plus_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: FLOAT_CLASS_NAME
    )
    float_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'less_than',
        implementation_name: 'less_than_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    float_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'less_than_or_equal_to',
        implementation_name: 'less_than_or_equal_to_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    float_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'more_than',
        implementation_name: 'more_than_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    float_class.methods_declarations << Ritournelle::IntermediateRepresentation::IntrinsicMethod.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        declared_name: 'more_than_or_equal_to',
        implementation_name: 'more_than_or_equal_to_Float',
        parameters_classes: [FLOAT_CLASS_NAME],
        return_class: BOOLEAN_CLASS_NAME
    )
    
    classes_declarations[FLOAT_CLASS_NAME] = float_class

    void_class = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: 'lib/ritournelle/intermediate_representation/world.rb',
        line_index: -1,
        name: VOID_CLASS_NAME,
        rdoc_name: SMALL_VOID_CLASS_NAME
    )
    classes_declarations[VOID_CLASS_NAME] = void_class

    classes_declarations[WORLD_CLASS_NAME] = self
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