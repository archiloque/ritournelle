class Ritournelle::CodeGenerator::Variable < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Variable] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    context.declare_variable(
        name: ir.name,
        clazz: ir.type,
        generator: self)
    @result = []
  end
end
