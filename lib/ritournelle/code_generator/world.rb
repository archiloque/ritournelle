require_relative '../intermediate_representation/world'

class Ritournelle::CodeGenerator::World

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] world
  def initialize(world)
    @result = []
    @world = world
    world.statements.each do |statement|
      generator_class = Ritournelle::CodeGenerator::GENERATORS[statement.class]
      unless generator_class
        raise "Can't find a generator for [#{statement.class}]"
      end
      generator = generator_class.new(statement)
      result.concat(generator.result)
    end
  end

end