class Ritournelle::CodeGenerator::Assignment

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] assignment
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(assignment, context)
    value = assignment.value
    if value.is_a?(String)
      @result = [
          "#{assignment.name} = #{value}"
      ]
    else
      @result = [
          "#{assignment.name} ="
      ] + context.generator(value).result.collect { |l| "  #{l}" }
    end
  end
end