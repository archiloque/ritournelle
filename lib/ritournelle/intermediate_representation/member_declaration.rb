require_relative '../keywords'

class Ritournelle::IntermediateRepresentation::MemberDeclaration < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::Keywords

  FORBIDDEN_NAMES = [
      KEYWORD_CLASS
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
      raise_error("Forbidden member name [#{name}]")
    end
    @name = name
  end

  # @return [Array<String>]
  def generics
    []
  end

end
