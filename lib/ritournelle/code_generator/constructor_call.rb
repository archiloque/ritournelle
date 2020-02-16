class Ritournelle::CodeGenerator::ConstructorCall < Ritournelle::CodeGenerator::Base

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::ConstructorCall] ir
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(ir:, context:)
    super(ir: ir, context: context)
    constructor = context.find_constructor(constructor_call: ir, generator: self)
    clazz = constructor.parent
    if [Ritournelle::BaseClasses::INT_CLASS_NAME, Ritournelle::BaseClasses::FLOAT_CLASS_NAME].include?(clazz.name)
      line = "#{clazz.rdoc_name}.new("
    else
      line = "#{clazz.rdoc_name}.new(#{constructor.index}, "
    end
    line << ir.parameters.collect do |parameter|
      case parameter
      when Integer
        parameter
      when Float
        parameter
      when Ritournelle::IntermediateRepresentation::ConstructorCall
        generate([parameter]).first
      else
        raise_error(parameter)
      end
    end.join(', ')
    line << ")"
    @result = [
        line
    ]
  end

end