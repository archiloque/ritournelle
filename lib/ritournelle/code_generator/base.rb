class Ritournelle::CodeGenerator::Base

  # @param [Ritournelle::IntermediateRepresentation::Base] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    @context = context
    @ir = ir
  end

  # @param [Array<Ritournelle::IntermediateRepresentation::Base>] statements
  # @return [Array<String>]
  def generate(statements)
    result = []
    statements.each do |statement|
      result.concat(
          @context.generator(statement: statement, generator: self).result
      )
    end
    result
  end

  # @param [String] message
  # @raise [RuntimeError]
  def raise_error(message)
    raise RuntimeError, message, (["#{@ir.file_path}:#{@ir.line_index}"] + caller)
  end

end