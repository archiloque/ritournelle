class Ritournelle::CodeGenerator::InterfaceDeclaration < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::InterfaceDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    @result = [
        "",
        "# @!parse",
        "#   # @abstract",
        "#   module #{ir.rdoc_name}",
    ]
    @result.concat(generate(ir.statements).map { |l| "#     #{l}" })
    @result.concat(
        [
            "#   end",
            ""
        ])
  end
end
