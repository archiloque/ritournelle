class Ritournelle::CodeGenerator::AbstractMethodDeclaration < Ritournelle::CodeGenerator::Base

  include Ritournelle::CodeGenerator::Callable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::AbstractMethodDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    @result = []
    @result.concat(generate_parameters_rdoc(ir: ir, context: context))
    result << "# @return [#{context.find_class_declaration(name: ir.return_class, generator: self).rdoc_name}]"
    result << "# @abstract"
    result << "# @note Declared name is #{ir.declared_name}"
    @result << generate_signature(ir)
    @result.concat(
        [
            "end",
            ""
        ])
  end
end
