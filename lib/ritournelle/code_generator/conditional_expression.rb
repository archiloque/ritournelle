class Ritournelle::CodeGenerator::ConditionalExpression < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConditionalExpression] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    @result = []
    case ir.conditional_statement_type
    when Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE,
        Ritournelle::IntermediateRepresentation::Type::TYPE_MEMBER
      element = context.find_element(
          name: ir.conditional_statement,
          types_to_look_for: Ritournelle::CodeGenerator::Context::ELEMENT_ANY,
          generator: self)
      if element.type == Ritournelle::BaseClasses::BOOLEAN_CLASS_NAME
        result << "if #{element.ir.name}.value"
      else
        raise_error("Element [#{ir.conditional_statement}] should be a Boolean but is a #{element.type}")
      end
    when Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL
      called_method = context.find_method(method_call: ir.conditional_statement, generator: self)
      if called_method.return_class == Ritournelle::BaseClasses::BOOLEAN_CLASS_NAME
        inner_code = generate([ir.conditional_statement])
        if inner_code.length != 1
          raise_error("Inner code is not the right length #{inner_code}")
        end
        result << "if #{inner_code.first}"
      else
        raise_error("#{ir.conditional_statement} should return a Boolean but returns a #{called_method.return_class}")
      end
    else
      raise_error(ir.conditional_statement_type)
    end
    @result.concat(generate(ir.statements).map { |l| "  #{l}" })
    @result << 'end'
  end

end