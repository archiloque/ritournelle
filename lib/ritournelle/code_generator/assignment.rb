class Ritournelle::CodeGenerator::Assignment < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    variable_name = ir.name
    context.find_variable_class(name: variable_name, generator: self)
    variable_value = ir.value
    if variable_value.is_a?(String)
      @result = [
          "#{variable_name} = #{variable_value}"
      ]
    else
      @result = [
          "#{variable_name} ="
      ] + generate([variable_value]).collect { |l| "  #{l}" }
    end
  end
end