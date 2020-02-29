class Ritournelle::IntermediateRepresentation::InterfaceDeclaration < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :name

  # @return [String]
  attr_reader :rdoc_name

  # @return [Array<Ritournelle::IntermediateRepresentation::AbstractMethodDeclaration>]
  attr_reader :abstract_methods_declarations

  alias_method :callables_declarations, :abstract_methods_declarations

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] name
  def initialize(file_path:, line_index:, name:, rdoc_name: name)
    super(file_path: file_path, line_index: line_index)
    @name = name
    @rdoc_name = rdoc_name
    @abstract_methods_declarations = []
  end

  # :nocov:
  def to_s
    "Interface declaration #{@name}"
  end
  # :nocov:

  def generics_declarations
    []
  end

end
