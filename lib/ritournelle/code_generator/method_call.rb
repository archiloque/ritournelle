class Ritournelle::CodeGenerator::MethodCall < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    variable_name = ir.variable_name
    element = context.find_element(name: variable_name, generator: self)
    unless element.initialized
      raise_error("Variable [#{variable_name}] is not initialized")
    end
    method = context.find_method(method_call: ir, generator: self)
    parameters = ir.parameters.map do |parameter|
      case parameter
      when String
        parameter
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        generate([parameter]).first
      else
        raise_error(parameter)
      end
    end
    @result = [
        "#{variable_name}.#{method.implementation_name}(#{parameters.join(', ')})"
    ]
  end

end