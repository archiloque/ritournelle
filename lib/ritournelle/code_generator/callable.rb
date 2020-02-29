module Ritournelle::CodeGenerator::Callable

  # @param [Ritournelle::IntermediateRepresentation::Callable] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def declare_parameters(ir:, context:)
    0.upto(ir.number_of_parameters - 1).each do |parameter_index|
      context.declare_parameter(
          name: ir.parameters_names[parameter_index],
          clazz: ir.parameters_classes[parameter_index],
          generator: self)
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::Callable] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  # @return [Array<String>]
  def generate_parameters_rdoc(ir:, context:)
    0.upto(ir.number_of_parameters - 1).map do |parameter_index|
      parameter_class_name = ir.parameters_classes[parameter_index]
      parameter_class = context.find_class_like_declaration(
          name: parameter_class_name,
          types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS | Ritournelle::CodeGenerator::Context::TYPE_INTERFACE,
          generator: self
      )
      parameter_name = ir.parameters_names[parameter_index]
      "# @param [#{parameter_class.rdoc_name}] #{parameter_name}"
    end
  end

  # @param [Ritournelle::IntermediateRepresentation::Callable] ir
  # @return [String]
  def generate_signature(ir)
    "def #{ir.implementation_name}(#{ir.parameters_names.join(', ')})"
  end

  # @param [Ritournelle::IntermediateRepresentation::WithStatements] ir
  # @return [Array<String>]
  def generate_body(ir)
    generate(ir.statements).map { |l| "  #{l}" }
  end
end