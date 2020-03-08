require_relative '../base_classes'
require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::Context

  # @return [Hash{String=>Ritournelle::CodeGenerator::Context::Member}]
  attr_reader :members

  CONTEXT_TYPE_CLASS = 'Class'
  CONTEXT_TYPE_METHOD = 'Method'
  CONTEXT_TYPE_CONSTRUCTOR = 'Constructor'
  CONTEXT_TYPE_WORLD = 'World'

  ELEMENT_SELF = 1 << 0
  ELEMENT_PARAMETER = 1 << 1
  ELEMENT_VARIABLE = 1 << 2
  ELEMENT_MEMBER = 1 << 3
  ELEMENT_ANY = (ELEMENT_SELF | ELEMENT_PARAMETER | ELEMENT_VARIABLE | ELEMENT_MEMBER)

  TYPE_CLASS = 1 << 0
  TYPE_INTERFACE = 1 << 1
  TYPE_GENERICS = 1 << 2
  TYPE_ANY = (TYPE_CLASS | TYPE_INTERFACE | TYPE_GENERICS)

  include Ritournelle::BaseClasses

  # @param [Ritournelle::CodeGenerator::Context, nil] parent
  # @param [Ritournelle::IntermediateRepresentation::Base] statement
  # @param [String] context_type
  def initialize(parent:, statement:, context_type:)
    super()
    @parent = parent
    @statement = statement
    @context_type = context_type
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Parameter}]
    @parameters = {}
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Variable}]
    @variables = {}
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Member}]
    @members = {}
    # @type [Hash{String=>Ritournelle::IntermediateRepresentation::ClassDeclaration}]
    @classes_declarations = {}
    # @type [Hash{String=>Ritournelle::IntermediateRepresentation::InterfaceDeclaration}]
    @interfaces_declarations = {}
    # @type [Array<Ritournelle::IntermediateRepresentation::GenericDeclaration>]
    @generics_declarations = []
  end

  def to_s
    "Context of #{@statement.to_s}"
  end

  # @param [Ritournelle::IntermediateRepresentation::Base] statement
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::CodeGenerator::Base]
  # @raise [RuntimeError]
  def generator(statement:, generator:)
    generator_class = Ritournelle::CodeGenerator::GENERATORS[statement.class]
    unless generator_class
      raise "Can't find a generator for [#{statement.class}]"
    end
    generator_class.new(ir: statement, context: self)
  end

  # Find a parameter or a variable or self
  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @param [Integer] types_to_look_for
  # @return [Ritournelle::CodeGenerator::Context::Parameter, Ritournelle::CodeGenerator::Context::Variable, Ritournelle::CodeGenerator::Context::Member, Ritournelle::CodeGenerator::Context::Self] the variable class
  # @raise [RuntimeError]
  def find_element(name:, types_to_look_for:, generator:)
    if (types_to_look_for & ELEMENT_SELF) && (name == Ritournelle::Keywords::KEYWORD_SELF)
      Ritournelle::CodeGenerator::Context::Self.new(@statement)
    elsif (types_to_look_for & ELEMENT_PARAMETER) && @parameters.key?(name)
      @parameters[name]
    elsif (types_to_look_for & ELEMENT_VARIABLE) && @variables.key?(name)
      @variables[name]
    elsif (types_to_look_for & ELEMENT_MEMBER) && @parent && @parent.members.key?(name)
      @parent.members[name]
    else
      generator.raise_error("Can't find element [#{name}] in #{self}")
    end
  end

  # @param [Object] value
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ClassDeclaration, Ritournelle::IntermediateRepresentation::InterfaceDeclaration]
  def find_type(value:, generator:)
    case value
    when Ritournelle::IntermediateRepresentation::ConstructorCall
      type_to_find = value.type
    when Ritournelle::IntermediateRepresentation::MethodCall
      type_to_find = find_method_return_type(method_call: value, generator: generator)
    else
      element = find_element(name: value, types_to_look_for: ELEMENT_ANY, generator: generator)
      type_to_find = element.type
    end
    find_class_like_declaration(
        name: type_to_find,
        types_to_look_for: TYPE_CLASS | TYPE_INTERFACE,
        generator: generator
    )
  end

  # @param [Ritournelle::IntermediateRepresentation::VariableDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  # @raise [RuntimeError]
  def declare_variable(ir:, generator:)
    if @variables.key?(ir.name)
      generator.raise_error("Variable [#{ir.name}] already exists in #{self}")
    else
      declared_class = find_class_like_declaration(
          name: ir.type,
          types_to_look_for: TYPE_CLASS | TYPE_INTERFACE | TYPE_GENERICS,
          generator: generator
      )
      if declared_class.generics_declarations.length != ir.generics.length
        generator.raise_error("Class [#{declared_class.name}] requires #{declared_class.generics_declarations.length} generic(s) but #{ir.generics.length} generic(s) detected")
      end
      @variables[ir.name] = Ritournelle::CodeGenerator::Context::Variable.new(ir)
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::MemberDeclaration] ir
  # @return [void]
  # @raise [RuntimeError]
  def declare_member(ir:)
    @members[ir.name] = Ritournelle::CodeGenerator::Context::Member.new(ir)
  end

  # @param [String] name
  # @param [String] clazz
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  # @raise [RuntimeError]
  def declare_parameter(name:, clazz:, generator:)
    if @variables.key?(name)
      generator.raise_error("Variable [#{name}] already exists in #{self}")
    elsif @parameters.key?(name)
      generator.raise_error("Parameter [#{name}] already exists in #{self}")
    else
      @parameters[name] = Ritournelle::CodeGenerator::Context::Parameter.new(clazz)
    end
  end

  # @param [String] name
  # @param [Integer] types_to_look_for
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ClassDeclaration, Ritournelle::IntermediateRepresentation::InterfaceDeclaration, Ritournelle::IntermediateRepresentation::GenericDeclaration]
  def find_class_like_declaration(name:, types_to_look_for:, generator:)
    if (types_to_look_for & TYPE_CLASS) && @classes_declarations.key?(name)
      @classes_declarations[name]
    elsif (types_to_look_for & TYPE_INTERFACE) && @interfaces_declarations.key?(name)
      @interfaces_declarations[name]
    elsif (types_to_look_for & TYPE_GENERICS) && @generics_declarations.any? { |generic_declaration| generic_declaration.name == name }
      @generics_declarations.find { |generic_declaration| generic_declaration.name == name }
    elsif @parent
      begin
        @parent.find_class_like_declaration(name: name, types_to_look_for: types_to_look_for, generator: generator)
      rescue
        generator.raise_error("Can't find [#{name}] in #{self}")
      end
    else
      generator.raise_error("Can't find [#{name}] in #{self}")
    end
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] class_declaration
  # @return [void]
  def declare_class(name:, class_declaration:)
    @classes_declarations[name] = class_declaration
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::InterfaceDeclaration] interface_declaration
  # @return [void]
  def declare_interface(name:, interface_declaration:)
    @interfaces_declarations[name] = interface_declaration
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::GenericDeclaration] generic_declaration
  # @return [void]
  def declare_generic(generic_declaration:)
    @generics_declarations << generic_declaration
  end

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::MethodDeclaration]
  # @raise [RuntimeError]
  def find_method(method_call:, generator:)
    element_name = method_call.element_name
    caller = find_element(
        name: element_name,
        types_to_look_for: (ELEMENT_MEMBER | ELEMENT_VARIABLE | ELEMENT_SELF | ELEMENT_PARAMETER),
        generator: generator
    )
    caller_type = caller.type
    caller_class = find_class_like_declaration(
        name: caller_type,
        types_to_look_for: TYPE_CLASS | TYPE_INTERFACE,
        generator: generator
    )
    generics_mapping = {}
    caller_class.generics_declarations.each_with_index do |generic_declaration, generic_index|
      generics_mapping[generic_declaration.name] = caller.ir.generics[generic_index]
    end
    find_callable(
        name: method_call.method_name,
        parameters: method_call.parameters,
        parameters_types: method_call.parameters_types,
        callables: caller_class.callables_declarations,
        start_of_signature: "#{caller_class.name}##{method_call.method_name}",
        generator: generator,
        generics_mapping: generics_mapping
    )
  end

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [String]
  # @raise [RuntimeError]
  def find_method_return_type(method_call:, generator:)
    element_name = method_call.element_name
    caller = find_element(
        name: element_name,
        types_to_look_for: (ELEMENT_MEMBER | ELEMENT_VARIABLE | ELEMENT_SELF | ELEMENT_PARAMETER),
        generator: generator
    )
    caller_class = find_class_like_declaration(
        name: caller.type,
        types_to_look_for: TYPE_CLASS | TYPE_INTERFACE,
        generator: generator
    )
    method = find_callable(
        name: method_call.method_name,
        parameters: method_call.parameters,
        parameters_types: method_call.parameters_types,
        callables: caller_class.callables_declarations,
        start_of_signature: "#{caller_class.name}##{method_call.method_name}",
        generator: generator)
    return_class = method.return_class
    possible_generic_index = caller_class.generics_declarations.index do |generic_declaration|
      generic_declaration.name == return_class
    end
    if possible_generic_index.nil?
      return_class
    else
      caller.ir.generics[possible_generic_index]
    end
  end


  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] constructor_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ConstructorDeclaration]
  # @raise [RuntimeError]
  def find_constructor(constructor_call:, generator:)
    clazz = find_class_like_declaration(
        name: constructor_call.type,
        types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS,
        generator: self
    )
    if constructor_call.generics.length != clazz.generics_declarations.length
      generator.raise_error("Class [#{clazz.name}] requires #{clazz.generics_declarations.length} generic(s) but #{constructor_call.generics.length} generic(s) detected")
    end
    find_callable(
        name: Ritournelle::Keywords::KEYWORD_CONSTRUCTOR,
        parameters: constructor_call.parameters,
        parameters_types: constructor_call.parameters_types,
        callables: clazz.constructors,
        start_of_signature: "#{clazz.name}##{Ritournelle::Keywords::KEYWORD_CONSTRUCTOR}",
        generator: generator,
        declared_generics: clazz.generics_declarations.map(&:name))
  end

  class Variable

    # @return [Boolean]
    attr_accessor :declared

    # @return [Boolean]
    attr_accessor :initialized

    # @return [Ritournelle::IntermediateRepresentation::VariableDeclaration]
    attr_reader :ir

    # @param [Ritournelle::IntermediateRepresentation::VariableDeclaration] ir
    def initialize(ir)
      @ir = ir
      @declared = false
      @initialized = false
    end

    def type
      @ir.type
    end

  end

  class Parameter

    # @return [String]
    attr_reader :type

    # @param [String] type
    def initialize(type)
      @type = type
    end

    # @return [Boolean]
    def initialized
      true
    end

    # @return [Boolean]
    def declared
      true
    end

  end

  class Self

    # @param [Ritournelle::IntermediateRepresentation::Base] statement
    def initialize(statement)
      @statement = statement
    end

    # @return [String]
    def type
      @statement.name
    end

    # @return [Boolean]
    def initialized
      true
    end

    # @return [Boolean]
    def declared
      true
    end
  end

  class Member

    # @return [Ritournelle::IntermediateRepresentation::MemberDeclaration]
    attr_reader :ir

    # @param [Ritournelle::IntermediateRepresentation::MemberDeclaration] ir
    def initialize(ir)
      @ir = ir
    end

    def type
      @ir.type
    end

    # @return [Boolean]
    def initialized
      true
    end

    # @return [Boolean]
    def declared
      true
    end

  end

  private

  # @param [String] name
  # @param [Array] parameters
  # @param [Array<String>] parameters_types
  # @param [Array<Ritournelle::IntermediateRepresentation::Callable>] callables
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @param [String] start_of_signature
  # @param [Array<String>] declared_generics
  # @param [Hash{String=>String}] generics_mapping
  # @return [Ritournelle::IntermediateRepresentation::Callable]
  # @raise [RuntimeError]
  def find_callable(
      name:,
      parameters:,
      parameters_types:,
      callables:,
      start_of_signature:,
      generator:,
      declared_generics: [],
      generics_mapping: {})
    parameters_classes_names = calculate_parameters_classes_names(generator, parameters, parameters_types)
    callables.each do |possible_method|
      if can_call?(
          name: name,
          parameters_classes_names: parameters_classes_names,
          callable: possible_method,
          declared_generics: declared_generics,
          generics_mapping: generics_mapping
      )
        return possible_method
      end
    end

    has_at_least_one_interface = false
    possible_param_types = parameters_classes_names.map do |parameter_class_name|
      parameter_class = find_class_like_declaration(
          name: parameter_class_name,
          types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS,
          generator: generator
      )
      implemented_interfaces = parameter_class.implemented_interfaces
      if implemented_interfaces.length > 0
        has_at_least_one_interface = true
      end
      [parameter_class_name] + implemented_interfaces
    end

    if has_at_least_one_interface
      if possible_param_types.length == 1
        possible_combinations = possible_param_types[0].product
      else
        possible_combinations = possible_param_types[0].product(*possible_param_types[1..-1])
      end
      candidates = []
      possible_combinations.select do |possible_parameters_classes|
        callables.each do |possible_method|
          if can_call?(
              name: name,
              parameters_classes_names: possible_parameters_classes,
              callable: possible_method,
              declared_generics: declared_generics,
              generics_mapping: generics_mapping
          )
            candidates << possible_method
          end
        end
      end
      if candidates.length == 1
        return candidates[0]
      elsif candidates.length > 1
        generator.raise_error("Callable [#{start_of_signature}(#{parameters_classes_names.join(', ')})] matched several candidates: #{candidates.map { |candidate| "#{start_of_signature}(#{candidate.parameters_classes.join(', ')})" }.join(', ')}")
      end
    else
      generator.raise_error("Can't find callable [#{start_of_signature}(#{parameters_classes_names.join(', ')})]")
    end
  end

  # @param [String] name
  # @return [Array<String>] parameters_classes_names
  # @param [Ritournelle::IntermediateRepresentation::Callable] callable
  # @param [Array<String>] declared_generics
  # @param [Hash{String=>String}] generics_mapping
  # @return [Boolean]
  def can_call?(name:, parameters_classes_names:, callable:, declared_generics:, generics_mapping:)
    if callable.declared_name != name
      false
    else
      callable.parameters_classes.each_with_index do |parameter_class, parameter_index|
        required_class = parameters_classes_names[parameter_index]
        if parameter_class == required_class
        elsif declared_generics.include?(parameter_class)
        elsif generics_mapping.key?(parameter_class) && (generics_mapping[parameter_class] == required_class)
        else
          return false
        end
      end
      true
    end
  end

  # @param [Ritournelle::CodeGenerator::Base] generator
  # @param [Array] parameters
  # @param [Array<String>] parameters_types
  # @return [Array<String>]
  def calculate_parameters_classes_names(generator, parameters, parameters_types)
    parameters_types.map.with_index do |parameter_type, parameter_index|
      case parameter_type
      when Ritournelle::BaseClasses::INTEGER_CLASS_NAME
        Ritournelle::BaseClasses::INTEGER_CLASS_NAME
      when Ritournelle::BaseClasses::FLOAT_CLASS_NAME
        Ritournelle::BaseClasses::FLOAT_CLASS_NAME
      when Ritournelle::BaseClasses::BOOLEAN_CLASS_NAME
        Ritournelle::BaseClasses::BOOLEAN_CLASS_NAME
      when Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
        parameters[parameter_index].type
      when Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER
        find_element(name: parameters[parameter_index], types_to_look_for: ELEMENT_ANY, generator: generator).type
      else
        generator.raise_error(parameter_type)
      end
    end
  end

end