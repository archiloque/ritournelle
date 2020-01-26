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
  # @return [Ritournelle::CodeGenerator::Base]
  def generator(statement:)
    generator_class = Ritournelle::CodeGenerator::GENERATORS[statement.class]
    unless generator_class
      raise "Can't find a generator for [#{statement.class}]"
    end
    generator_class.new(ir: statement, context: self)
  end

  # @param [String] name
  # @return [String] the variable class
  def find_variable(name)
    if name == Ritournelle::Keywords::KEYWORD_SELF
      return @statement.name
    end
    unless @variables.key?(name)
      raise "Can't find variable [#{name}] in #{self}"
    end
    @variables[name]
  end


  # @param [String] name
  # @param [String] clazz
  # @return [void]
  def add_variable(name, clazz)
    if @variables.key?(name)
      raise "Variable already exists [#{name}] in #{self}"
    end
    @variables[name] = clazz
  end

  # @param [String] name
  # @return [Ritournelle::IntermediateRepresentation::Class]
  def find_class(name)
    if @clazzez.key?(name)
      @clazzez[name]
    elsif @parent
      begin
        @parent.find_class(name)
      rescue
        raise "Can't find class [#{name}] in #{self}"
      end
    else
      raise "Can't find class [#{name}] in #{self}"
    end
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::Class] clazz
  # @return [void]
  def add_class(name, clazz)
    if @clazzez.key(name)
      raise "Class already exists [#{name}] in #{self}"
    end
    @clazzez[name] = clazz
  end

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @return [Ritournelle::IntermediateRepresentation::Method]
  def find_method(method_call)
    variable_name = method_call.variable_name
    caller_class_name = find_variable(variable_name)
    caller_class = find_class(caller_class_name)
    parameters_classes = method_call.parameters.collect do |parameter|
      if parameter.is_a?(Integer)
        SMALL_INT_CLASS_NAME
      elsif parameter.is_a?(Float)
        SMALL_FLOAT_CLASS_NAME
      else
        find_variable(parameter)
      end
    end
    method = caller_class.methodz.find do |possible_method|
      (possible_method.declared_name == method_call.method_name) &&
          (possible_method.parameters_classes == parameters_classes)
    end
    if method.nil?
      raise "Can't find method [#{caller_class.name}##{method_call.method_name}(#{parameters_classes.join(', ')})]"
    end
    method
  end

end