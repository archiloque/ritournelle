require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::Context

  # @return [Array<String>]
  attr_reader :result

  # @return [Hash{String,String}]
  attr_reader :variables

  # @return [Ritournelle::IntermediateRepresentation::World]
  attr_reader :world

  # @param [Ritournelle::IntermediateRepresentation::World] world
  def initialize(world)
    @result = []
    @variables = {}
    @world = world
    world.statements.each do |statement|
      result.concat(generator(statement).result)
    end

  end

  def generator(statement)
    generator_class = Ritournelle::CodeGenerator::GENERATORS[statement.class]
    unless generator_class
      raise "Can't find a generator for [#{statement.class}]"
    end
    generator_class.new(statement, self)
  end

end