class Ritournelle::CodeGenerator::MethodCall < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    variable_name = ir.variable_name
    method = context.find_method(method_call: ir, generator: self)
    output_parameters = ir.parameters.map do |parameter|
      case parameter
      when String
        parameter
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        generate([parameter]).first
      end
    end
    @result = [
        "#{variable_name}.#{method.implementation_name}(#{output_parameters.join(', ')})"
    ]
  end

end