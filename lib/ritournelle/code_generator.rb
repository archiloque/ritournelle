class Ritournelle::CodeGenerator

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] world
  def initialize(world)
    @world = world
    @result = Ritournelle::CodeGenerator::Context.new(world).result
  end

end

require_relative 'code_generator/assignment'
require_relative 'code_generator/class'
require_relative 'code_generator/constructor_call'
require_relative 'code_generator/method_call'
require_relative 'code_generator/variable'

require_relative 'code_generator/context'

class Ritournelle::CodeGenerator
  GENERATORS = {
      Ritournelle::IntermediateRepresentation::Assignment => Ritournelle::CodeGenerator::Assignment,
      Ritournelle::IntermediateRepresentation::ConstructorCall => Ritournelle::CodeGenerator::ConstructorCall,
      Ritournelle::IntermediateRepresentation::MethodCall => Ritournelle::CodeGenerator::MethodCall,
      Ritournelle::IntermediateRepresentation::Variable => Ritournelle::CodeGenerator::Variable,
      Ritournelle::IntermediateRepresentation::Class => Ritournelle::CodeGenerator::Class,
  }
end