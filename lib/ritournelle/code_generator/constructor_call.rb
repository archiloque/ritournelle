class Ritournelle::CodeGenerator::ConstructorCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] constructor_call
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(constructor_call, context)

    parameter = constructor_call.parameters[0]

    if parameter.is_a?(Integer)
      clazz = "Ritournelle::Runtime::StdLib::Int"
    elsif parameter.is_a?(Float)
      clazz = "Ritournelle::Runtime::StdLib::Float"
    else
      raise
    end
    @result = [
        "#{clazz}.new(#{parameter})"
    ]
  end

end