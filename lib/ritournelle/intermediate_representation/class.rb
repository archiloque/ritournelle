class Ritournelle::IntermediateRepresentation::Class

  # @return [String]
  attr_reader :name

  # @return [Array<Ritournelle::IntermediateRepresentation::Constructor>]
  attr_reader :constructors

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methods

  # @param [String] name
  def initialize(name)
    @name = name
    @constructors = []
    @methods = []
  end

end
