require_relative '../keywords'

class Ritournelle::IntermediateRepresentation::Variable

  include Ritournelle::Keywords

  FORBIDDEN_NAMES = [
      KEYWORD_CLASS,
      KEYWORD_RETURN
  ]

  # @return [String]
  attr_reader :type

  # @return [String]
  attr_reader :name

  # @param [String] type
  # @param [String] name
  def initialize(type:, name:)
    @type = type
    if FORBIDDEN_NAMES.include?(name)
      raise "Forbidden variable name [#{name}]"
    end
    @name = name
  end

end
