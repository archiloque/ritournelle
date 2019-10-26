class Ritournelle::IntermediateRepresentation::Constructor

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [Array<String>]
  attr_reader :parameters_names

  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  def initialize(parameters_classes, parameters_names)
    @parameters_classes = parameters_classes
    @parameters_names = parameters_names
  end

end