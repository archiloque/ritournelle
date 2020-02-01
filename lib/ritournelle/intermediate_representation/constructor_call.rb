class Ritournelle::IntermediateRepresentation::ConstructorCall < Ritournelle::IntermediateRepresentation::Base

  # @return [Ritournelle::IntermediateRepresentation::Class]
  attr_reader :parent

  # @return [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>]
  attr_reader :parameters

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Ritournelle::IntermediateRepresentation::Class] parent
  # @param [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>] parameters
  def initialize(file_path:, line_index:, parent:, parameters:)
    super(file_path: file_path, line_index: line_index)
    @parent = parent
    @parameters = parameters
  end

end
