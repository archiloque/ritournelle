class Ritournelle::CodeGenerator::Method < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Method] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    method_context = Ritournelle::CodeGenerator::Context.new(parent: context, statement: ir)
    super(ir: ir, context: method_context)
    0.upto(ir.number_of_parameters - 1).each do |parameter_index|
      method_context.declare_parameter(
          name: ir.parameters_names[parameter_index],
          clazz: ir.parameters_classes[parameter_index],
          generator: self)
    end
    @result = [""]
    0.upto(ir.number_of_parameters - 1).each do |parameter_index|
      parameter_class_name = ir.parameters_classes[parameter_index]
      parameter_class = context.find_class(name: parameter_class_name, generator: self)
      parameter_name = ir.parameters_names[parameter_index]
      result << "# @param [#{parameter_class.rdoc_name}] #{parameter_name}"
    end
    result << "# @return [#{context.find_class(name: ir.return_class, generator: self).rdoc_name}]"
    @result << "def #{ir.implementation_name}(#{ir.parameters_names.join(', ')})"
    @result.concat(generate(ir.statements).map { |l| "  #{l}" })
    @result.concat(
        [
            "end",
            ""
        ])
  end

end