class Ritournelle::IntermediateRepresentation::IntrinsicMethod < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :declared_name

  # @return [String]
  attr_reader :implementation_name

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [String]
  attr_reader :return_class

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] declared_name
  # @param [String] implementation_name
  # @param [Array<String>] parameters_classes
  # @param [String] return_class
  def initialize(file_path:, line_index:, declared_name:, implementation_name:, parameters_classes:, return_class:)
    super(file_path: file_path, line_index: line_index)
    @declared_name = declared_name
    @implementation_name = implementation_name
    @parameters_classes = parameters_classes
    @return_class = return_class
  end

  # :nocov:
  def to_s
    "Method #{return_class} #{declared_name}(#{parameters_classes.join(', ')})"
  end
  # :nocov:

end
