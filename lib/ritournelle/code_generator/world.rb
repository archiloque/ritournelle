class Ritournelle::CodeGenerator::World < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] ir
  def initialize(ir:)
    context = Ritournelle::CodeGenerator::Context.new(
        parent: nil,
        statement: ir,
        context_type: Ritournelle::CodeGenerator::Context::CONTEXT_TYPE_WORLD)
    ir.classes_declarations.each_pair do |class_name, class_declaration|
      context.declare_class(name: class_name, class_declaration: class_declaration)
    end
    ir.interfaces_declarations.each_pair do |interface_name, interface_declaration|
      context.declare_interface(name: interface_name, interface_declaration: interface_declaration)
    end
    super(ir: ir, context: context)
    @result = generate(ir.statements)
  end
end
