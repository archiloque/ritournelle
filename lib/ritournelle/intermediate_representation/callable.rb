class Ritournelle::IntermediateRepresentation::Callable < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :implementation_name

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [Array<String>]
  attr_reader :parameters_names

  # @return [Integer]
  attr_reader :number_of_parameters

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  def initialize(file_path:, line_index:, parameters_classes:, parameters_names:, implementation_name:)
    super(file_path: file_path, line_index: line_index)
    @parameters_classes = parameters_classes
    @parameters_names = parameters_names
    @number_of_parameters = parameters_classes.length
    @implementation_name = implementation_name
  end

end