class Ritournelle::CodeGenerator::Return < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Return] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(context)
    inner_code = generate([ir.value])
    if inner_code.length != 1
      raise "Inner code is not thr right length #{inner_code}"
    end
    @result = ["return #{inner_code.first}"]
  end
end
