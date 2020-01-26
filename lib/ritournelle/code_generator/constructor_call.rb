class Ritournelle::CodeGenerator::ConstructorCall < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(context)
    parameter = ir.parameters[0]

    case parameter
    when Integer
      clazz = Ritournelle::Runtime::StdLib::Int.name
    when Float
      clazz = Ritournelle::Runtime::StdLib::Float.name
    else
      raise parameter.to_s
    end
    @result = [
        "#{clazz}.new(#{parameter})"
    ]
  end

end