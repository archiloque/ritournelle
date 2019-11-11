class Ritournelle::IntermediateRepresentation::Class

  # @return [String]
  attr_reader :name

  # @return [Array<Ritournelle::IntermediateRepresentation::Constructor>]
  attr_reader :constructors

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methods

  # @return [Hash{String, Ritournelle::IntermediateRepresentation::Method}]
  attr_reader :members

  # @param [String] name
  def initialize(name)
    @name = name
    @constructors = []
    @methods = []
    @members = {}
  end

end
