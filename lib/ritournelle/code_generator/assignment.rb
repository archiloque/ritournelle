class Ritournelle::CodeGenerator::Assignment < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    target_name = ir.name
    target = context.find_element(
        name: target_name,
        types_to_look_for: (Ritournelle::CodeGenerator::Context::ELEMENT_VARIABLE | Ritournelle::CodeGenerator::Context::ELEMENT_MEMBER),
        generator: self)
    @result = []
    unless target.declared
      result << "# @type [#{context.find_class(name: target.ir.type, generator: self).rdoc_name}]"
      target.declared = true
    end
    unless target.initialized
      target.initialized = true
    end
    variable_value = ir.value
    if variable_value.is_a?(String)
      @result << "#{target_name} = #{variable_value}"
    else
      @result << "#{target_name} ="
      @result.concat(generate([variable_value]).collect { |l| "  #{l}" })
    end
  end
end