class Ritournelle::CodeGenerator::Variable < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Variable] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    context.add_variable(ir.name, ir.type)
    @result = []
  end
end
