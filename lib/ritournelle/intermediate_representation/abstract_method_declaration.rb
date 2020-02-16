class Ritournelle::IntermediateRepresentation::AbstractMethodDeclaration < Ritournelle::IntermediateRepresentation::Callable

  # @return [String]
  attr_reader :declared_name

  # @return [String]
  attr_reader :return_class

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration, Ritournelle::IntermediateRepresentation::World] parent
  # @param [String] declared_name
  # @param [Array<String>] parameters_classes
  # @param [Array<String>] parameters_names
  # @param [String] return_class
  # @param [Integer] method_index
  def initialize(file_path:, line_index:, parent:, declared_name:, parameters_classes:, parameters_names:, return_class:, method_index:)
    implementation_name = "#{declared_name.gsub(/[^a-z_\d]/, '')}—#{method_index}"
    super(
        file_path: file_path,
        line_index: line_index,
        parameters_classes: parameters_classes,
        parameters_names: parameters_names,
        implementation_name: implementation_name
    )
    @parent = parent
    @declared_name = declared_name
    @return_class = return_class
  end

  # :nocov:
  def to_s
    "Abstract method declaration #{return_class} #{@parent.name}##{declared_name}(" +
        0.upto(number_of_parameters - 1).map do |index|
          "#{parameters_classes[index]} #{parameters_names[index]}"
        end.join(', ') + ')'
  end
  # :nocov:

end
