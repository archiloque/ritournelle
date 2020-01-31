class Ritournelle::CodeGenerator::Return < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Return] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    expected_class = ir.parent.return_class
    case ir.value
    when Ritournelle::IntermediateRepresentation::ConstructorCall
      found_class = ir.value.parent.name
      unless found_class == expected_class
        raise_error("The method should return a #{expected_class} but return a #{found_class}")
      end
    when Ritournelle::IntermediateRepresentation::MethodCall
      found_class = context.find_method(method_call: ir.value, generator: self).return_class
      unless found_class == expected_class
        raise_error("The method should return a #{expected_class} but return a #{found_class}")
      end
    else
      raise_error(ir.value.to_s)
    end
    inner_code = generate([ir.value])
    if inner_code.length != 1
      raise_error("Inner code is not the right length #{inner_code}")
    end
    @result = ["return #{inner_code.first}"]
  end
end
