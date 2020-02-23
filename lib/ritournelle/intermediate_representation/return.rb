class Ritournelle::IntermediateRepresentation::Return < Ritournelle::IntermediateRepresentation::Base

  # @return [Ritournelle::IntermediateRepresentation::MethodDeclaration]
  attr_reader :parent

  attr_reader :value

  attr_reader :type

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Ritournelle::IntermediateRepresentation::MethodDeclaration] parent
  # @param [Object] value
  # @param [String] type
  def initialize(file_path:, line_index:, parent:, value:, type:)
    super(file_path: file_path, line_index: line_index)
    @parent = parent
    @value = value
    @type = type
  end
end
