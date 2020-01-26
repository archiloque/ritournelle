class Ritournelle::CodeGenerator::MethodCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    variable_name = ir.variable_name
    caller_class_name = context.variable(variable_name)
    caller_class = context.clazz(caller_class_name)
    parameters_classes = ir.parameters.collect do |parameter|
      if parameter.is_a?(Integer)
        'int'
      elsif parameter.is_a?(Float)
        'float'
      else
        context.variable(parameter)
      end
    end
    method = caller_class.methodz.find do |possible_method|
      (possible_method.declared_name == ir.method_name) &&
          (possible_method.parameters_classes == parameters_classes)
    end
    if method.nil?
      raise "Can't find method [#{caller_class.name}##{ir.method_name}(#{parameters_classes.join(', ')})]"
    end
    @result = [
        "#{variable_name}.#{method.implementation_name}(#{ir.parameters.join(', ')})"
    ]
  end

end