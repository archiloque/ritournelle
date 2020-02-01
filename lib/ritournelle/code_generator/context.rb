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
    @variables = {}
    @clazzez = {}
  end

  def to_s
    "Context of #{@statement.to_s}"
  end

  # @param [Object] statement
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::CodeGenerator::Base]
  def generator(statement:, generator:)
    generator_class = Ritournelle::CodeGenerator::GENERATORS[statement.class]
    unless generator_class
      generator.raise_error("Can't find a generator for [#{statement.class}]")
    end
    generator_class.new(ir: statement, context: self)
  end

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [String] the variable class
  def find_variable_class(name:, generator:)
    if name == Ritournelle::Keywords::KEYWORD_SELF
      return @statement.name
    end
    unless @variables.key?(name)
      generator.raise_error("Can't find variable [#{name}] in #{self}")
    end
    @variables[name]
  end

  # @param [String] name
  # @param [String] clazz
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [void]
  def declare_variable(name:, clazz:, generator:)
    if @variables.key?(name)
      generator.raise_error("Variable already exists [#{name}] in #{self}")
    end
    @variables[name] = clazz
  end

  # @param [String] name
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::Class]
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
    end
    @clazzez[name] = clazz
  end

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Base] generator
  # @return [Ritournelle::IntermediateRepresentation::Method]
  def find_method(method_call:, generator:)
    variable_name = method_call.variable_name
    caller_class_name = find_variable_class(name: variable_name, generator: generator)
    caller_class = find_class(name: caller_class_name, generator: generator)
    parameters_classes = method_call.parameters.collect do |parameter|
      case parameter
      when String
        find_variable_class(name: parameter, generator: generator)
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

end