class Ritournelle::CodeGenerator::Method < Ritournelle::CodeGenerator::Base

  include Ritournelle::CodeGenerator::Callable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Method] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    method_context = Ritournelle::CodeGenerator::Context.new(
        parent: context,
        statement: ir,
        context_type: Ritournelle::CodeGenerator::Context::CONTEXT_TYPE_METHOD)
    super(ir: ir, context: method_context)
    declare_parameters(ir: ir, context: method_context)
    @result = [""]

    @result.concat(generate_parameters_rdoc(ir: ir, context: method_context))

    result << "# @return [#{method_context.find_class(name: ir.return_class, generator: self).rdoc_name}]"
    @result << generate_signature(ir)
    @result.concat(generate_body(ir))
    @result.concat(
        [
            "end",
            ""
        ])
  end

end