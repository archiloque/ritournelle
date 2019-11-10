class Ritournelle::IntermediateRepresentation::Method

  # @return [String]
  attr_reader :declared_name

  # @return [String]
  attr_reader :implementation_name

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [String]
  attr_reader :return_class

  # @param [String] declared_name
  # @param [String] implementation_name
  # @param [Array<String>] parameters_classes
  # @param [String] return_class
  def initialize(declared_name, implementation_name, parameters_classes, return_class)
    @declared_name = declared_name
    @implementation_name = implementation_name
    @parameters_classes = parameters_classes
    @return_class = return_class
  end

end
