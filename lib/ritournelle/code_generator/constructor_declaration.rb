class Ritournelle::CodeGenerator::ConstructorDeclaration < Ritournelle::CodeGenerator::Base

  include Ritournelle::CodeGenerator::Callable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    constructor_context = Ritournelle::CodeGenerator::Context.new(
        parent: context,
        statement: ir,
        context_type: Ritournelle::CodeGenerator::Context::CONTEXT_TYPE_CONSTRUCTOR)
    super(ir: ir, context: constructor_context)
    declare_parameters(ir: ir, context: constructor_context)
    @result = [""]

    @result.concat(generate_parameters_rdoc(ir: ir, context: constructor_context))

    @result << generate_signature(ir)
    @result.concat(generate_body(ir))
    @result.concat(
        [
            "end",
            ""
        ])
  end

end