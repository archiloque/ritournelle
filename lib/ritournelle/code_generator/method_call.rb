class Ritournelle::IntermediateRepresentation::MethodCall

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::MethodCall] method_call
  def initialize(method_call)
    @method_call = method_call
  end

end