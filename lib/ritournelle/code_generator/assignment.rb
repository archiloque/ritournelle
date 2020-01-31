class Ritournelle::CodeGenerator::Assignment < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    value = ir.value
    if value.is_a?(String)
      @result = [
          "#{ir.name} = #{value}"
      ]
    else
      @result = [
          "#{ir.name} ="
      ] + generate([value]).collect { |l| "  #{l}" }
    end
  end
end