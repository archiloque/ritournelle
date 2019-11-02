class Ritournelle::IntermediateRepresentation::MethodCall

  # @return [String]
  attr_reader :variable_name

  # @return [String]
  attr_reader :method_name

  # @return [Array]
  attr_reader :parameters

  # @param [String] variable_name
  # @param [String] method_name
  # @param [Array] parameters
  def initialize(variable_name, method_name, parameters)
    @variable_name = variable_name
    @method_name = method_name
    @parameters = parameters
  end

end
