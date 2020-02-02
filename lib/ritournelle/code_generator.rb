class Ritournelle::CodeGenerator

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] world
  def initialize(world:)
    @world = world
    @result = Ritournelle::CodeGenerator::World.new(ir: world).result
  end

end

require_relative 'code_generator/base'
require_relative 'code_generator/callable'

require_relative 'code_generator/assignment'
require_relative 'code_generator/class'
require_relative 'code_generator/constructor'
require_relative 'code_generator/constructor_call'
require_relative 'code_generator/method'
require_relative 'code_generator/method_call'
require_relative 'code_generator/return'
require_relative 'code_generator/variable'
require_relative 'code_generator/world'

require_relative 'code_generator/context'

class Ritournelle::CodeGenerator
  GENERATORS = {
      Ritournelle::IntermediateRepresentation::Assignment => Ritournelle::CodeGenerator::Assignment,
      Ritournelle::IntermediateRepresentation::ConstructorCall => Ritournelle::CodeGenerator::ConstructorCall,
      Ritournelle::IntermediateRepresentation::Constructor => Ritournelle::CodeGenerator::Constructor,
      Ritournelle::IntermediateRepresentation::Method => Ritournelle::CodeGenerator::Method,
      Ritournelle::IntermediateRepresentation::MethodCall => Ritournelle::CodeGenerator::MethodCall,
      Ritournelle::IntermediateRepresentation::Return => Ritournelle::CodeGenerator::Return,
      Ritournelle::IntermediateRepresentation::Variable => Ritournelle::CodeGenerator::Variable,
      Ritournelle::IntermediateRepresentation::Class => Ritournelle::CodeGenerator::Class,
  }
end