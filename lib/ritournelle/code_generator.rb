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
require_relative 'code_generator/class_declaration'
require_relative 'code_generator/constructor_declaration'
require_relative 'code_generator/constructor_call'
require_relative 'code_generator/member_declaration'
require_relative 'code_generator/method_declaration'
require_relative 'code_generator/method_call'
require_relative 'code_generator/return'
require_relative 'code_generator/variable'
require_relative 'code_generator/world'

require_relative 'code_generator/context'

class Ritournelle::CodeGenerator
  GENERATORS = {
      Ritournelle::IntermediateRepresentation::Assignment => Ritournelle::CodeGenerator::Assignment,
      Ritournelle::IntermediateRepresentation::ClassDeclaration => Ritournelle::CodeGenerator::ClassDeclaration,
      Ritournelle::IntermediateRepresentation::ConstructorCall => Ritournelle::CodeGenerator::ConstructorCall,
      Ritournelle::IntermediateRepresentation::ConstructorDeclaration => Ritournelle::CodeGenerator::ConstructorDeclaration,
      Ritournelle::IntermediateRepresentation::MemberDeclaration => Ritournelle::CodeGenerator::MemberDeclaration,
      Ritournelle::IntermediateRepresentation::MethodDeclaration => Ritournelle::CodeGenerator::MethodDeclaration,
      Ritournelle::IntermediateRepresentation::MethodCall => Ritournelle::CodeGenerator::MethodCall,
      Ritournelle::IntermediateRepresentation::Return => Ritournelle::CodeGenerator::Return,
      Ritournelle::IntermediateRepresentation::Variable => Ritournelle::CodeGenerator::Variable,
  }
end