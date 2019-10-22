class Ritournelle::CodeGenerator

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] world
  def initialize(world)
    @world = world
    @result = Ritournelle::CodeGenerator::World.new(world).result
  end

end

require_relative 'code_generator/assignment'
require_relative 'code_generator/variable_declaration'
require_relative 'code_generator/world'

class Ritournelle::CodeGenerator
  GENERATORS = {
      Ritournelle::IntermediateRepresentation::Assignment => Ritournelle::CodeGenerator::Assignment,
      Ritournelle::IntermediateRepresentation::VariableDeclaration => Ritournelle::CodeGenerator::VariableDeclaration,
  }
end