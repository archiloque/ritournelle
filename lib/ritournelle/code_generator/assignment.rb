class Ritournelle::CodeGenerator::Assignment

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] assignment
  def initialize(assignment)
    @result = [
        "#{assignment.name} = #{assignment.value}"
    ]
  end
end
