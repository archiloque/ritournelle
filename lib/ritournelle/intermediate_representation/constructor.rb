class Ritournelle::IntermediateRepresentation::Constructor < Ritournelle::IntermediateRepresentation::Base

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [Array<String>]
  attr_reader :parameters_names

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  def initialize(file_path:, line_index:, parameters_classes:, parameters_names:)
    super(file_path: file_path, line_index: line_index)
    @parameters_classes = parameters_classes
    @parameters_names = parameters_names
  end

end