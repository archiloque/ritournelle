class Ritournelle::CodeGenerator::Class < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Class] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    class_context = Ritournelle::CodeGenerator::Context.new(parent: context, statement: ir)
    super(ir: ir, context: class_context)
    @result = [
        "",
        "class #{ir.name}"
    ]
    @result.concat(generate(ir.statements).map { |l| "  #{l}" })
    @result.concat(
        [
            "end",
            ""
        ])
  end
end