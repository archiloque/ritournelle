class Ritournelle::CodeGenerator::Method < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Method] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    method_context = Ritournelle::CodeGenerator::Context.new(parent: context, statement: ir)
    super(method_context)
    0.upto(ir.number_of_parameters - 1).each do |parameter_index|
      method_context.add_variable(ir.parameters_names[parameter_index], ir.parameters_classes[parameter_index])
    end
    @result = [""]
    0.upto(ir.number_of_parameters - 1).each do |parameter_index|
      parameter_class_name = ir.parameters_classes[parameter_index]
      parameter_class = context.find_class(parameter_class_name)
      parameter_name = ir.parameters_names[parameter_index]
      result << "# @param [#{parameter_class.rdoc_name}] #{parameter_name}"
    end
    result << "# @return [#{context.find_class(ir.return_class).rdoc_name}]"
    @result << "def #{ir.declared_name}(#{ir.parameters_names.join(', ')})"
    @result.concat(generate(ir.statements).map { |l| "  #{l}" })
    @result.concat(
        [
            "end",
            ""
        ])
  end

end