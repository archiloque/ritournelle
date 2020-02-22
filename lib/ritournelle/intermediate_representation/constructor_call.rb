class Ritournelle::IntermediateRepresentation::ConstructorCall < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :type

  # @return [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>]
  attr_reader :parameters

  # @return [Array<String>]
  attr_reader :parameters_types

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] type
  # @param [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>] parameters
  # @param [Array<String>] parameters_types
  def initialize(file_path:, line_index:, type:, parameters:, parameters_types:)
    super(file_path: file_path, line_index: line_index)
    @type = type
    @parameters = parameters
    @parameters_types = parameters_types
  end

  # :nocov:
  def to_s
    "Constructor call #{type}(#{parameters.join(', ')})"
  end
  # :nocov:

end
