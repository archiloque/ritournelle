class Ritournelle::IntermediateRepresentation::Method

  # @return [String]
  attr_reader :declared_name

  # @return [String]
  attr_reader :implementation_name

  # @return [Array<String>] parameters_classes
  attr_reader :parameters_classes

  # @param [String] declared_name
  # @param [String] implementation_name
  # @param [Array<String>] parameters_classes
  def initialize(declared_name, implementation_name, parameters_classes)
    @declared_name = declared_name
    @implementation_name = implementation_name
    @parameters_classes = parameters_classes
  end

end
