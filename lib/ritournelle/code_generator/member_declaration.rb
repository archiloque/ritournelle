class Ritournelle::CodeGenerator::MemberDeclaration < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MemberDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    context.declare_member(
        ir: ir
    )
    @result = []
  end
end
