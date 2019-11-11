require_relative '../keywords'

class Ritournelle::IntermediateRepresentation::Member

  include Ritournelle::Keywords

  FORBIDDEN_NAMES = [
      KEYWORD_CLASS
  ]

  # @return [String]
  attr_reader :type

  # @return [String]
  attr_reader :name

  # @param [String] type
  # @param [String] name
  def initialize(type, name)
    @type = type
    if FORBIDDEN_NAMES.include?(name)
      raise "Forbidden member name [#{name}]"
    end
    @name = name
  end

end
