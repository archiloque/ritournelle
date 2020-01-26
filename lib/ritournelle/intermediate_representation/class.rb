class Ritournelle::IntermediateRepresentation::Class

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :name

  # @return [Array<Ritournelle::IntermediateRepresentation::Constructor>]
  attr_reader :constructors

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methodz

  # @return [Hash{String, Ritournelle::IntermediateRepresentation::Method}]
  attr_reader :members

  # @param [String] name
  def initialize(name:)
    @name = name
    @constructors = []
    @methodz = []
    @members = {}
  end

  def to_s
    "Class #{@name}"
  end
end
