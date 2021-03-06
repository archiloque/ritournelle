require_relative '../keywords'

class Ritournelle::IntermediateRepresentation::VariableDeclaration < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::Keywords

  FORBIDDEN_NAMES = [
      KEYWORD_CLASS,
      KEYWORD_RETURN,
      KEYWORD_TRUE,
      KEYWORD_FALSE,
      KEYWORD_SELF,
  ]

  # @return [String]
  attr_reader :type

  # @return [String]
  attr_reader :name

  # @return [Array<String>]
  attr_reader :generics

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] type
  # @param [String] name
  # @param [Array<String>] generics
  def initialize(file_path:, line_index:, type:, name:, generics:)
    super(file_path: file_path, line_index: line_index)
    @type = type
    if FORBIDDEN_NAMES.include?(name)
      raise_error("Forbidden variable name [#{name}]")
    end
    @name = name
    @generics = generics
  end

  # :nocov:
  def to_s
    "Variable #{type} #{name}"
  end
  # :nocov:

end
