require_relative '../base_classes'
require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::Context

  include Ritournelle::BaseClasses

  # @param [Ritournelle::CodeGenerator::Context\nil] parent
  # @param [Object] statement
  def initialize(parent:, statement:)
    super()
    @parent = parent
    @statement = statement
    @parameters = {}
    # @type [Hash{String=>Ritournelle::CodeGenerator::Context::Variable}]
    @variables = {}
    @clazzez = {}
  end

  def to_s
    "Context of #{@statement.to_s}"
  end

  # @param [Object] statement
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
  # @return [String] the variable class
  # @raise [RuntimeError]
  def find_parameter_or_variable_class(name:, generator:)
    if name == Ritournelle::Keywords::KEYWORD_SELF
      return @statement.name
    end
    if @parameters.key?(name)
      @parameters[name]
    elsif @variables.key?(name)
      @variables[name].ir.type
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
      @parameters[name] = clazz
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
    caller_class_name = find_parameter_or_variable_class(name: variable_name, generator: generator)
    caller_class = find_class(name: caller_class_name, generator: generator)
    parameters_classes = method_call.parameters.collect do |parameter|
      case parameter
      when String
        find_parameter_or_variable_class(name: parameter, generator: generator)
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        parameter.parent.name
      else
        generator.raise_error(parameter.to_s)
      end
    end
    method = caller_class.methodz.find do |possible_method|
      (possible_method.declared_name == method_call.method_name) &&
          (possible_method.parameters_classes == parameters_classes)
    end
    if method.nil?
      generator.raise_error("Can't find method [#{caller_class.name}##{method_call.method_name}(#{parameters_classes.join(', ')})]")
    end
    method
  end

  class Variable

    # @return [Boolean]
    attr_accessor :declared

    # @return [Ritournelle::IntermediateRepresentation::Variable]
    attr_reader :ir

    # @param [Ritournelle::IntermediateRepresentation::Variable] ir
    def initialize(ir)
      @ir = ir
      @declared = false
    end

  end

end