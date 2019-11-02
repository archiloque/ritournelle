class Ritournelle::CodeGenerator::ConstructorCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] constructor_call
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(constructor_call, context)
    @result = [
        "Ritournelle::Runtime::StdLib::Int.new(#{constructor_call.parameters[0]})"
    ]
  end

end