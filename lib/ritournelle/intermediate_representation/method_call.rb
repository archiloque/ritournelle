class Ritournelle::IntermediateRepresentation::MethodCall < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :element_name

  # @return [String]
  attr_reader :method_name

  # @return [Array]
  attr_reader :parameters

  # @return [Array<String>]
  attr_reader :parameters_types

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] element_name
  # @param [String] method_name
  # @param [Array] parameters
  # @param [Array<String>] parameters_types
  def initialize(file_path:, line_index:, element_name:, method_name:, parameters:, parameters_types:)
    super(file_path: file_path, line_index: line_index)
    @element_name = element_name
    @method_name = method_name
    @parameters = parameters
    @parameters_types = parameters_types
  end

  # :nocov:
  def to_s
    "Method call #{element_name}.#{method_name}(#{parameters.join(', ')})"
  end
  # :nocov:

end
