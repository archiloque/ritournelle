class Ritournelle::IntermediateRepresentation::MethodCall < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :variable_name

  # @return [String]
  attr_reader :method_name

  # @return [Array]
  attr_reader :parameters

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] variable_name
  # @param [String] method_name
  # @param [Array] parameters
  def initialize(file_path:, line_index:, variable_name:, method_name:, parameters:)
    super(file_path: file_path, line_index: line_index)
    @variable_name = variable_name
    @method_name = method_name
    @parameters = parameters
  end

  def to_s
    "Method call #{variable_name}.#{method_name}(#{parameters.join(', ')})"
  end

end
