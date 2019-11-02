class Ritournelle::CodeGenerator::Variable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Variable] variable
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(variable, context)
    context.variables[variable.name] = variable.type
    @result = []
  end
end
