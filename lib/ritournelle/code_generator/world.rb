class Ritournelle::CodeGenerator::World < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::World] ir
  def initialize(ir:)
    context = Ritournelle::CodeGenerator::Context.new(parent: nil, statement: ir)
    ir.clazzez.each_pair do |class_name, clazz|
      context.add_class(name: class_name, clazz: clazz, generator: self)
    end
    super(ir: ir, context: context)
    @result = generate(ir.statements)
  end
end
