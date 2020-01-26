class Ritournelle::IntermediateRepresentation::Method

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :declared_name

  # @return [String]
  attr_reader :implementation_name

  # @return [Array<String>]
  attr_reader :parameters_classes

  # @return [Array<String>]
  attr_reader :parameters_names

  # @return [Integer]
  attr_reader :number_of_parameters

  # @return [String]
  attr_reader :return_class

  # @param [Object] parent
  # @param [String] declared_name
  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  # @param [String] return_class
  def initialize(parent:, declared_name:, parameters_classes:, parameters_names:, return_class:)
    @parent = parent
    @declared_name = declared_name
    @implementation_name = declared_name
    @parameters_classes = parameters_classes
    @parameters_names = parameters_names
    @number_of_parameters = parameters_classes.length
    @return_class = return_class
  end

  def to_s
    "Method #{return_class} #{@parent.name}##{declared_name}(" +
        0.upto(number_of_parameters - 1).map do |index|
          "#{parameters_classes[index]} #{parameters_names[index]}"
        end.join(', ') + ')'
  end

end
