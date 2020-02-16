class Ritournelle::CodeGenerator::ClassDeclaration < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    class_context = Ritournelle::CodeGenerator::Context.new(
        parent: context,
        statement: ir,
        context_type: Ritournelle::CodeGenerator::Context::CONTEXT_TYPE_CLASS)
    super(ir: ir, context: class_context)
    @result = [
        "",
        "class #{ir.name}"
    ]
    unless ir.constructors.empty?
      @result.concat(
          [
              "  # @param [Integer] constructor_index",
              "  def initialize(constructor_index, *parameters)",
              "    send(\"initialize—\#{constructor_index}\", *parameters)",
              "  end"
          ])
    end
    @result.concat(generate(ir.statements).map { |l| "  #{l}" })
    @result.concat(
        [
            "end",
            ""
        ])
  end
end