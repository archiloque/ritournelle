class Ritournelle::CodeGenerator::ConstructorCall < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    constructor = context.find_constructor(constructor_call: ir, generator: self)
    clazz = constructor.parent
    if [
        Ritournelle::BaseClasses::INTEGER_CLASS_NAME,
        Ritournelle::BaseClasses::FLOAT_CLASS_NAME,
        Ritournelle::BaseClasses::BOOLEAN_CLASS_NAME
    ].include?(clazz.name)
      line = "#{clazz.rdoc_name}.new("
    else
      line = "#{clazz.rdoc_name}.new(#{constructor.index}, "
    end
    line << ir.parameters_types.map.with_index do |parameter_type, parameter_index|
      parameter = ir.parameters[parameter_index]
      case parameter_type
      when Ritournelle::IntermediateRepresentation::Type::TYPE_INTEGER
        parameter
      when Ritournelle::IntermediateRepresentation::Type::TYPE_FLOAT
        parameter
      when Ritournelle::IntermediateRepresentation::Type::TYPE_BOOLEAN
        parameter
      when Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
        generate([parameter]).first
      else
        raise_error(parameter_type)
      end
    end.join(', ')
    line << ")"
    @result = [
        line
    ]
  end

end