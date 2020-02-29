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

require_relative 'code_generator/abstract_method_declaration'
require_relative 'code_generator/assignment'
require_relative 'code_generator/class_declaration'
require_relative 'code_generator/conditional_expression'
require_relative 'code_generator/constructor_declaration'
require_relative 'code_generator/constructor_call'
require_relative 'code_generator/generic_declaration'
require_relative 'code_generator/interface_declaration'
require_relative 'code_generator/member_declaration'
require_relative 'code_generator/method_declaration'
require_relative 'code_generator/method_call'
require_relative 'code_generator/return'
require_relative 'code_generator/variable_declaration'
require_relative 'code_generator/world'

require_relative 'code_generator/context'

class Ritournelle::CodeGenerator
  GENERATORS = {
      Ritournelle::IntermediateRepresentation::AbstractMethodDeclaration => Ritournelle::CodeGenerator::AbstractMethodDeclaration,
      Ritournelle::IntermediateRepresentation::Assignment => Ritournelle::CodeGenerator::Assignment,
      Ritournelle::IntermediateRepresentation::ClassDeclaration => Ritournelle::CodeGenerator::ClassDeclaration,
      Ritournelle::IntermediateRepresentation::ConditionalExpression => Ritournelle::CodeGenerator::ConditionalExpression,
      Ritournelle::IntermediateRepresentation::ConstructorCall => Ritournelle::CodeGenerator::ConstructorCall,
      Ritournelle::IntermediateRepresentation::ConstructorDeclaration => Ritournelle::CodeGenerator::ConstructorDeclaration,
      Ritournelle::IntermediateRepresentation::GenericDeclaration => Ritournelle::CodeGenerator::GenericDeclaration,
      Ritournelle::IntermediateRepresentation::InterfaceDeclaration => Ritournelle::CodeGenerator::InterfaceDeclaration,
      Ritournelle::IntermediateRepresentation::MemberDeclaration => Ritournelle::CodeGenerator::MemberDeclaration,
      Ritournelle::IntermediateRepresentation::MethodDeclaration => Ritournelle::CodeGenerator::MethodDeclaration,
      Ritournelle::IntermediateRepresentation::MethodCall => Ritournelle::CodeGenerator::MethodCall,
      Ritournelle::IntermediateRepresentation::Return => Ritournelle::CodeGenerator::Return,
      Ritournelle::IntermediateRepresentation::VariableDeclaration => Ritournelle::CodeGenerator::VariableDeclaration,
  }
end