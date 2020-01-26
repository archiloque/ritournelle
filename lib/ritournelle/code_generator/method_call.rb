class Ritournelle::CodeGenerator::MethodCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    variable_name = ir.variable_name
    method = context.find_method(ir)
    @result = [
        "#{variable_name}.#{method.implementation_name}(#{ir.parameters.join(', ')})"
    ]
  end

end