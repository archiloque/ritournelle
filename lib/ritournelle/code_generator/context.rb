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
      generator.raise_error("Can't find a generator for [#{statement.class}]")
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
      find_class_or_interface_declaration(name: value.type, generator: generator)
    when Ritournelle::IntermediateRepresentation::MethodCall
      method = find_method(method_call: value, generator: generator)
      find_class_or_interface_declaration(name: method.return_class, generator: generator)
    else
      element = find_element(name: value, types_to_look_for: ELEMENT_ANY, generator: generator)
      find_class_or_interface_declaration(name: element.type, generator: generator)
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::Variable] ir
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  # @raise [RuntimeError]
  def declare_variable(ir:, generator:)
    if @variables.key?(ir.name)
      generator.raise_error("Variable [#{ir.name}] already exists in #{self}")
    else
      @variables[ir.name] = Ritournelle::CodeGenerator::Context::Variable.new(ir)
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::MemberDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  # @raise [RuntimeError]
  def declare_member(ir:, generator:)
    if @members.key?(ir.name)
      generator.raise_error("Member [#{ir.name}] already exists in #{self}")
    else
      @members[ir.name] = Ritournelle::CodeGenerator::Context::Member.new(ir)
    end

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
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ClassDeclaration,Ritournelle::IntermediateRepresentation::InterfaceDeclaration]
  # @raise [RuntimeError]
  def find_class_or_interface_declaration(name:, generator:)
    if @classes_declarations.key?(name)
      @classes_declarations[name]
    elsif @interfaces_declarations.key?(name)
      @interfaces_declarations[name]
    elsif @parent
      begin
        @parent.find_class_or_interface_declaration(name: name, generator: generator)
      rescue
        generator.raise_error("Can't find class or interface [#{name}] in #{self}")
      end
    else
      generator.raise_error("Can't find class or interface [#{name}] in #{self}")
    end
  end

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ClassDeclaration]
  # @raise [RuntimeError]
  def find_class_declaration(name:, generator:)
    if @classes_declarations.key?(name)
      @classes_declarations[name]
    elsif @parent
      begin
        @parent.find_class_declaration(name: name, generator: generator)
      rescue
        generator.raise_error("Can't find class [#{name}] in #{self}")
      end
    else
      generator.raise_error("Can't find class [#{name}] in #{self}")
    end
  end

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::InterfaceDeclaration]
  # @raise [RuntimeError]
  def find_interface_declaration(name:, generator:)
    if @interfaces_declarations.key?(name)
      @interfaces_declarations[name]
    elsif @parent
      begin
        @parent.find_interface_declaration(name: name, generator: generator)
      rescue
        generator.raise_error("Can't find interface [#{name}] in #{self}")
      end
    else
      generator.raise_error("Can't find interface [#{name}] in #{self}")
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

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::MethodDeclaration]
  # @raise [RuntimeError]
  def find_method(method_call:, generator:)
    element_name = method_call.element_name
    caller_type = find_element(
        name: element_name,
        types_to_look_for: (ELEMENT_MEMBER | ELEMENT_VARIABLE | ELEMENT_SELF | ELEMENT_PARAMETER),
        generator: generator
    ).type
    caller_class = find_class_or_interface_declaration(name: caller_type, generator: generator)
    find_callable(
        name: method_call.method_name,
        parameters: method_call.parameters,
        callables: caller_class.callables_declarations,
        start_of_signature: "#{caller_class.name}##{method_call.method_name}",
        generator: generator)
  end

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] constructor_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::ConstructorDeclaration]
  # @raise [RuntimeError]
  def find_constructor(constructor_call:, generator:)
    clazz = find_class_declaration(name: constructor_call.type, generator: self)
    find_callable(
        name: 'constructor',
        parameters: constructor_call.parameters,
        callables: clazz.constructors,
        start_of_signature: "#{clazz.name}#constructor",
        generator: generator)
  end

  class Variable

    # @return [Boolean]
    attr_accessor :declared

    # @return [Boolean]
    attr_accessor :initialized

    # @return [Ritournelle::IntermediateRepresentation::Variable]
    attr_reader :ir

    # @param [Ritournelle::IntermediateRepresentation::Variable] ir
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
  # @param [Array<Ritournelle::IntermediateRepresentation::Callable>] callables
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @param [String] start_of_signature
  # @return [Ritournelle::IntermediateRepresentation::Callable]
  # @raise [RuntimeError]
  def find_callable(name:, parameters:, callables:, start_of_signature:, generator:)
    parameters_classes_names = parameters.collect do |parameter|
      case parameter
      when Integer
        Ritournelle::BaseClasses::SMALL_INT_CLASS_NAME
      when Float
        Ritournelle::BaseClasses::SMALL_FLOAT_CLASS_NAME
      when String
        find_element(name: parameter, types_to_look_for: ELEMENT_ANY, generator: generator).type
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        parameter.type
      else
        generator.raise_error(parameter.to_s)
      end
    end
    callable = callables.find do |possible_method|
      (possible_method.declared_name == name) &&
          (possible_method.parameters_classes == parameters_classes_names)
    end
    if callable
      return callable
    end
    has_at_least_of_interface = false
    possible_param_types = parameters_classes_names.map do |parameter_class_name|
      parameter_class = find_class_declaration(name: parameter_class_name, generator: generator)
      implemented_interfaces = parameter_class.implemented_interfaces
      if implemented_interfaces.length > 0
        has_at_least_of_interface = true
      end
      [parameter_class_name] + implemented_interfaces
    end
    if has_at_least_of_interface
      if possible_param_types.length == 1
        possible_combinations = possible_param_types[0].product()
      else
        possible_combinations = possible_param_types[0].product(*possible_param_types[1..-1])
      end
      candidates = []
      possible_combinations.select do |possible_parameters_classes|
        callables.each do |possible_method|
          if (possible_method.declared_name == name) &&
              (possible_method.parameters_classes == possible_parameters_classes)
            candidates << possible_method
          end
        end
      end
      if candidates.length == 1
        return candidates[0]
      elsif candidates.length > 1
        generator.raise_error("Callable [#{start_of_signature}(#{parameters_classes_names.join(', ')})] matched several candidates: #{candidates.map { |candidate| "#{start_of_signature}(#{candidate.parameters_classes.join(', ')})" }.join(', ')}")
      end
    end
    generator.raise_error("Can't find callable [#{start_of_signature}(#{parameters_classes_names.join(', ')})]")
  end

end