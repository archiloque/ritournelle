require_relative '../base_classes'
require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::Context

  include Ritournelle::BaseClasses

  # @param [Ritournelle::CodeGenerator::Context, nil] parent
  # @param [Ritournelle::IntermediateRepresentation::Base] statement
  def initialize(parent:, statement:)
    super()
    @parent = parent
    @statement = statement
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Parameter}]
    @parameters = {}
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Variable}]
    @variables = {}
    @clazzez = {}
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

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::CodeGenerator::Context::Variable]
  # @raise [RuntimeError]
  def find_variable(name:, generator:)
    if @variables.key?(name)
      @variables[name]
    else
      generator.raise_error("Can't find variable [#{name}] in #{self}")
    end
  end

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::CodeGenerator::Context::Parameter, Ritournelle::CodeGenerator::Context::Variable, Ritournelle::CodeGenerator::Context::Self] the variable class
  # @raise [RuntimeError]
  def find_element(name:, generator:)
    if name == Ritournelle::Keywords::KEYWORD_SELF
      return Ritournelle::CodeGenerator::Context::Self.new(@statement)
    end
    if @parameters.key?(name)
      @parameters[name]
    elsif @variables.key?(name)
      @variables[name]
    else
      generator.raise_error("Can't find variable or parameter [#{name}] in #{self}")
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
  # @return [Ritournelle::IntermediateRepresentation::Class]
  # @raise [RuntimeError]
  def find_class(name:, generator:)
    if @clazzez.key?(name)
      @clazzez[name]
    elsif @parent
      begin
        @parent.find_class(name: name, generator: generator)
      rescue
        generator.raise_error("Can't find class [#{name}] in #{self}")
      end
    else
      generator.raise_error("Can't find class [#{name}] in #{self}")
    end
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::Class] clazz
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  def declare_class(name:, clazz:, generator:)
    if @clazzez.key(name)
      generator.raise_error("Class already exists [#{name}] in #{self}")
    else
      @clazzez[name] = clazz
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::Method]
  # @raise [RuntimeError]
  def find_method(method_call:, generator:)
    variable_name = method_call.variable_name
    caller_type = find_element(name: variable_name, generator: generator).type
    caller_class = find_class(name: caller_type, generator: generator)
    find_callable(
        name: method_call.method_name,
        parameters: method_call.parameters,
        callables: caller_class.methodz,
        start_of_signature: "#{caller_class.name}##{method_call.method_name}",
        generator: generator)
  end

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] constructor_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::Constructor]
  # @raise [RuntimeError]
  def find_constructor(constructor_call:, generator:)
    clazz = find_class(name: constructor_call.type, generator: self)
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

  private

  # @param [String] name
  # @param [Array] parameters
  # @param [Array<Ritournelle::IntermediateRepresentation::Callable>] callables
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @param [String] start_of_signature
  # @return [Ritournelle::IntermediateRepresentation::Callable]
  # @raise [RuntimeError]
  def find_callable(name:, parameters:, callables:, start_of_signature:, generator:)
    parameters_classes = parameters.collect do |parameter|
      case parameter
      when Integer
        Ritournelle::BaseClasses::SMALL_INT_CLASS_NAME
      when Float
        Ritournelle::BaseClasses::SMALL_FLOAT_CLASS_NAME
      when String
        find_element(name: parameter, generator: generator).type
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        parameter.type
      else
        generator.raise_error(parameter.to_s)
      end
    end
    callable = callables.find do |possible_method|
      (possible_method.declared_name == name) &&
          (possible_method.parameters_classes == parameters_classes)
    end
    if callable.nil?
      generator.raise_error("Can't find callable [#{start_of_signature}(#{parameters_classes.join(', ')})]")
    end
    callable
  end

end