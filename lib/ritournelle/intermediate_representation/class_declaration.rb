class Ritournelle::IntermediateRepresentation::ClassDeclaration < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :name

  # @return [String]
  attr_reader :rdoc_name

  # @return [Array<Ritournelle::IntermediateRepresentation::ConstructorDeclaration>]
  attr_reader :constructors

  # @return [Array<Ritournelle::IntermediateRepresentation::MethodDeclaration>]
  attr_reader :methods_declarations

  alias_method :callables_declarations, :methods_declarations

  # @return [Hash{String=>Ritournelle::IntermediateRepresentation::MethodDeclaration}]
  attr_reader :members

  # @return [Array<String>]
  attr_reader :implemented_interfaces

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] name
  def initialize(file_path:, line_index:, name:, rdoc_name: name)
    super(file_path: file_path, line_index: line_index)
    @name = name
    @rdoc_name = rdoc_name
    @constructors = []
    @methods_declarations = []
    @implemented_interfaces = []
    @members = {}
  end

  # :nocov:
  def to_s
    "Class declaration #{@name}"
  end
  # :nocov:

end
