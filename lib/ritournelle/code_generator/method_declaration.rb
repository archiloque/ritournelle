class Ritournelle::CodeGenerator::MethodDeclaration < Ritournelle::CodeGenerator::Base

  include Ritournelle::CodeGenerator::Callable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    method_context = Ritournelle::CodeGenerator::Context.new(
        parent: context,
        statement: ir,
        context_type: Ritournelle::CodeGenerator::Context::CONTEXT_TYPE_METHOD)
    super(ir: ir, context: method_context)
    declare_parameters(ir: ir, context: method_context)
    @result = (generate_parameters_rdoc(ir: ir, context: method_context))

    result << "# @return [#{method_context.find_class_declaration(name: ir.return_class, generator: self).rdoc_name}]"
    result << "# @note Declared name is #{ir.declared_name}"
    @result << generate_signature(ir)
    @result.concat(generate_body(ir))
    @result << 'end'
  end

end