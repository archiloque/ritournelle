class Ritournelle::IntermediateRepresentation::ConstructorDeclaration < Ritournelle::IntermediateRepresentation::Callable

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :implementation_name

  # @return [Integer]
  attr_reader :index

  # @return [Ritournelle::IntermediateRepresentation::ClassDeclaration]
  attr_reader :parent

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] parent
  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  def initialize(file_path:, line_index:, parent:, parameters_classes:, parameters_names:)
    @index = parent.constructors.length
    super(
        file_path: file_path,
        line_index: line_index,
        parameters_classes: parameters_classes,
        parameters_names: parameters_names,
        implementation_name: "initialize—#{@index}"
    )
    @parent = parent
  end

  # @return [String]
  def declared_name
    Ritournelle::Keywords::KEYWORD_CONSTRUCTOR
  end

  # :nocov:
  def to_s
    "Constructor declaration ##{@parent.name}(" +
        0.upto(number_of_parameters - 1).map do |index|
          "#{parameters_classes[index]} #{parameters_names[index]}"
        end.join(', ') + ')'
  end
  # :nocov:

end