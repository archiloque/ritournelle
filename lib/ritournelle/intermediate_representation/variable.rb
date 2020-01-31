require_relative '../keywords'

class Ritournelle::IntermediateRepresentation::Variable < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::Keywords

  FORBIDDEN_NAMES = [
      KEYWORD_CLASS,
      KEYWORD_RETURN
  ]

  # @return [String]
  attr_reader :type

  # @return [String]
  attr_reader :name

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] type
  # @param [String] name
  def initialize(file_path:, line_index:, type:, name:)
    super(file_path: file_path, line_index: line_index)
    @type = type
    if FORBIDDEN_NAMES.include?(name)
      raise_error("Forbidden variable name [#{name}]")
    end
    @name = name
  end

end
