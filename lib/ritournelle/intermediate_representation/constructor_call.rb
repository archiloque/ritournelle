class Ritournelle::IntermediateRepresentation::ConstructorCall < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :type

  # @return [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>]
  attr_reader :parameters

  # @return [Array<String>]
  attr_reader :parameters_types

  # @return [Array<String>]
  attr_reader :generics

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] type
  # @param [Array<Ritournelle::IntermediateRepresentation::Base, Integer, Float>] parameters
  # @param [Array<String>] parameters_types
  # @param [Array<String>] generics
  def initialize(file_path:, line_index:, type:, parameters:, parameters_types:, generics:)
    super(file_path: file_path, line_index: line_index)
    @type = type
    @parameters = parameters
    @parameters_types = parameters_types
    @generics = generics
  end

  # :nocov:
  def to_s
    "Constructor call #{type}(#{parameters.join(', ')})"
  end
  # :nocov:

end
