class Ritournelle::IntermediateRepresentation::Assignment < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :name

  attr_reader :value

  # @param [String] name
  # @param value
  def initialize(file_path:, line_index:, name:, value:)
    super(file_path: file_path, line_index: line_index)
    @name = name
    @value = value
  end
end
