class Ritournelle::IntermediateRepresentation::Assignment < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :target_name

  attr_reader :value

  # @return [String] One of the Ritournelle::IntermediateRepresentation::Type types
  attr_reader :value_type

  # @param [String] target_name
  # @param value
  # @param [String] value_type One of the Ritournelle::IntermediateRepresentation::Type types
  def initialize(file_path:, line_index:, target_name:, value:, value_type:)
    super(file_path: file_path, line_index: line_index)
    @target_name = target_name
    @value = value
    @value_type = value_type
  end
end
