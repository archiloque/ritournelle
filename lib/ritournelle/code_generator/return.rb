class Ritournelle::CodeGenerator::Return < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Return] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    expected_class = ir.parent.return_class
    case ir.type
    when Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
      found_class = ir.value.type
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    when Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL
      called_method = context.find_method(method_call: ir.value, generator: self)
      found_class = called_method.return_class
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    when Ritournelle::IntermediateRepresentation::Type::VARIABLE_OR_MEMBER
      target = context.find_element(
          name: ir.value,
          types_to_look_for: Ritournelle::CodeGenerator::Context::ELEMENT_ANY,
          generator: self)
      found_class = target.type
      unless found_class == expected_class
        raise_error("#{ir.parent} should return a #{expected_class} but returns a #{found_class}")
      end
    else
      raise_error(ir.type)
    end

    case ir.type
    when Ritournelle::IntermediateRepresentation::Type::VARIABLE_OR_MEMBER
      @result = ["return #{ir.value}"]
    when Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL
      inner_code = generate([ir.value])
      if inner_code.length != 1
        raise_error("Inner code is not the right length #{inner_code}")
      end
      @result = ["return #{inner_code.first}"]
    when Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
      inner_code = generate([ir.value])
      if inner_code.length != 1
        raise_error("Inner code is not the right length #{inner_code}")
      end
      @result = ["return #{inner_code.first}"]
    else
      raise_error(ir.type)
    end
  end
end
