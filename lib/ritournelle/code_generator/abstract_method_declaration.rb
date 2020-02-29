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
    rdoc_name = context.find_class_like_declaration(
        name: ir.return_class,
        types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS,
        generator: self
    ).rdoc_name
    result << "# @return [#{rdoc_name}]"
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
