class Ritournelle::IntermediateRepresentation::ConstructorCall < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :type

  # @return [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>]
  attr_reader :parameters

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] type
  # @param [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>] parameters
  def initialize(file_path:, line_index:, type:, parameters:)
    super(file_path: file_path, line_index: line_index)
    @type = type
    @parameters = parameters
  end

  # :nocov:
  def to_s
    "Constructor call #{type}(#{parameters.join(', ')})"
  end
  # :nocov:

end
