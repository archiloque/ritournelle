class Ritournelle::CodeGenerator::Member < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Variable] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    context.declare_member(
        ir: ir,
        generator: self)
    @result = []
  end
end
