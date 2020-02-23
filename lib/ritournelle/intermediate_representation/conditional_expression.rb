class Ritournelle::IntermediateRepresentation::ConditionalExpression < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String, Ritournelle::IntermediateRepresentation::MethodCall]
  attr_reader :conditional_statement

  # @return [String]
  attr_reader :conditional_statement_type

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String, Ritournelle::IntermediateRepresentation::MethodCall] conditional_statement
  # @param [String] conditional_statement_type
  def initialize(file_path:, line_index:, conditional_statement:, conditional_statement_type:)
    super(file_path: file_path, line_index: line_index)
    @conditional_statement = conditional_statement
    @conditional_statement_type = conditional_statement_type
  end

  # :nocov:
  def to_s
    "Conditional expression #{@conditional_statement}"
  end
  # :nocov:

end
