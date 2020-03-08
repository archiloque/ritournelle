class Ritournelle::CodeGenerator::Assignment < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Assignment] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    target_name = ir.target_name
    target = context.find_element(
        name: target_name,
        types_to_look_for: (Ritournelle::CodeGenerator::Context::ELEMENT_VARIABLE | Ritournelle::CodeGenerator::Context::ELEMENT_MEMBER),
        generator: self)
    check_assignability(ir: ir, context: context, target: target)
    @result = []
    unless target.declared
      rdoc_name = context.find_class_like_declaration(
          name: target.ir.type,
          types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS | Ritournelle::CodeGenerator::Context::TYPE_INTERFACE,
          generator: self).rdoc_name
      result << "# @type [#{rdoc_name}#{target.ir.generics.empty? ? '' : "<#{target.ir.generics.join(', ')}>"}]"
      target.declared = true
    end
    unless target.initialized
      target.initialized = true
    end
    variable_value = ir.value
    case ir.value_type
    when Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE,
        Ritournelle::IntermediateRepresentation::Type::TYPE_MEMBER,
        Ritournelle::IntermediateRepresentation::Type::TYPE_PARAMETER
      @result << "#{target_name} = #{variable_value}"
    else
      @result << "#{target_name} ="
      @result.concat(generate([variable_value]).collect { |l| "  #{l}" })
    end
  end

  private

  # @param [Ritournelle::CodeGenerator::Context] context
  # @param [Ritournelle::IntermediateRepresentation::Assignment] ir
  def check_assignability(ir:, context:, target:)
    target_type = context.find_class_like_declaration(
        name: target.ir.type,
        types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS | Ritournelle::CodeGenerator::Context::TYPE_INTERFACE,
        generator: self
    )
    value_type = context.find_type(value: ir.value, generator: self)
    if target_type != value_type
      found_interface = value_type.implemented_interfaces.any? do |interface_name|
        interface = context.find_class_like_declaration(
            name: interface_name,
            types_to_look_for: Ritournelle::CodeGenerator::Context::TYPE_CLASS | Ritournelle::CodeGenerator::Context::TYPE_INTERFACE,
            generator: self)
        target_type == interface
      end
      unless found_interface
        raise_error("Can't assign a #{value_type.name} as a #{target_type.name}")
      end
    end

    target_generics = target.ir.generics

    case ir.value_type
    when Ritournelle::IntermediateRepresentation::Type::TYPE_PARAMETER
      value_generics = []
    when Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE
      target = context.find_element(
          name: ir.value,
          types_to_look_for: (Ritournelle::CodeGenerator::Context::ELEMENT_VARIABLE),
          generator: self)
      value_generics = target.ir.generics
    when Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL
      value_generics = []
    when Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
      value_generics = ir.value.generics
    else
      raise_error ir.value_type
    end

    if value_generics != target_generics
      raise_error("Generics mismatch : [#{value_generics.join(', ')}] vs [#{target_generics.join(', ')}]")
    end
  end
end