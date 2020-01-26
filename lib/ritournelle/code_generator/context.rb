require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::Context

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
  def variable(name)
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
  # @return [Ritournelle::IntermediateRepresentation::Class}]
  def clazz(name)
    if @clazzez.key?(name)
      @clazzez[name]
    elsif @parent
      begin
        @parent.clazz(name)
      rescue
        raise "Can't find class [#{name}] in #{self}"
      end
    else
      raise "Can't find class [#{name}] in #{self}"
    end
  end

  # @param [String] name
  # @param [Ritournelle::IntermediateRepresentation::Class}] clazz
  # @return [void]
  def add_clazz(name, clazz)
    if @clazzez.key(name)
      raise "Class already exists [#{name}] in #{self}"
    end
    @clazzez[name] = clazz
  end

end