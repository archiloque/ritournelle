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
      found_class = ir.value.type
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    when Ritournelle::IntermediateRepresentation::MethodCall
      called_method = context.find_method(method_call: ir.value, generator: self)
      found_class = called_method.return_class
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    when String
      target = context.find_element(
          name: ir.value,
          types_to_look_for: Ritournelle::CodeGenerator::Context::ELEMENT_ANY,
          generator: self)
      found_class = target.type
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    else
      raise_error(ir.value.to_s)
    end
    case ir.value
    when String
      @result = ["return #{ir.value}"]
    else
      inner_code = generate([ir.value])
      if inner_code.length != 1
        raise_error("Inner code is not the right length #{inner_code}")
      end
      @result = ["return #{inner_code.first}"]
    end
  end
end
