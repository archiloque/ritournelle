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
    ir.generics_declarations.each do |generic_declaration|
      class_context.declare_generic(
          generic_declaration: generic_declaration
      )
    end
    validate_interfaces_implementations(ir: ir, context: context)
    @result = [
        "",
        "class #{ir.name}"
    ]
    unless ir.implemented_interfaces.empty?
      @result << "  # @!parse"
      ir.implemented_interfaces.each do |implemented_interface_name|
        @result << "  #   include #{implemented_interface_name}"
      end
      @result << ""
    end
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

  private

  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def validate_interfaces_implementations(ir:, context:)
    ir.implemented_interfaces.each do |interface_name|
      interface_declaration = context.find_class_like_declaration(
          name: interface_name,
          types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_INTERFACE,
          generator: self
      )
      interface_declaration.abstract_methods_declarations.each do |abstract_method_definition|
        found_method = ir.methods_declarations.any? do |method_declaration|
          (abstract_method_definition.declared_name == method_declaration.declared_name) &&
              (abstract_method_definition.parameters_classes == method_declaration.parameters_classes)
        end
        unless found_method
          raise_error("Class [#{ir.name}] should implement interface [#{interface_name}] but is missing method #{abstract_method_definition.declared_name}(#{abstract_method_definition.parameters_classes.join(', ')})")
        end
      end
    end
  end

end