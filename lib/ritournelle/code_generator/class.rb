class Ritournelle::CodeGenerator::Class

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Class] clazz
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(clazz, context)
    @result = [
        "class #{clazz.name}",
        "end"
    ]
  end

end