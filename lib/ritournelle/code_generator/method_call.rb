class Ritournelle::CodeGenerator::MethodCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(method_call, context)
    caller_class_name = context.variables[method_call.variable_name]
    caller_class = context.world.classes[caller_class_name]
    parameters_classes = method_call.parameters.collect do |parameter|
      if parameter.is_a?(Integer)
        'int'
      else
        context.variables[method_call.variable_name]
      end
    end
    method = caller_class.methods.find do |possible_method|
      possible_method.declared_name == method_call.method_name
      possible_method.parameters_classes == parameters_classes
    end
    @result = [
        "#{method_call.variable_name}.#{method.implementation_name}(#{method_call.parameters.join(', ')})"
    ]
  end

end