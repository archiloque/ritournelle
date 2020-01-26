class Ritournelle::CodeGenerator::ConstructorCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)

    parameter = ir.parameters[0]

    if parameter.is_a?(Integer)
      clazz = Ritournelle::Runtime::StdLib::Int.name
    elsif parameter.is_a?(Float)
      clazz = Ritournelle::Runtime::StdLib::Float.name
    else
      raise
    end
    @result = [
        "#{clazz}.new(#{parameter})"
    ]
  end

end