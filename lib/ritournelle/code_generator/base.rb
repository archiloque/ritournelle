class Ritournelle::CodeGenerator::Base

  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(context)
    @context = context
  end

  # @param [Array] statements
  # @return [Array<String>]
  def generate(statements)
    result = []
    statements.each do |statement|
      result.concat(
          @context.generator(statement: statement).result
      )
    end
    result
  end
end