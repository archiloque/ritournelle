class Ritournelle::IntermediateRepresentation::GenericDeclaration < Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :name

  # @return [String]
  attr_reader :rdoc_name

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] name
  def initialize(file_path:, line_index:, name:, rdoc_name: name)
    super(file_path: file_path, line_index: line_index)
    @name = name
    @rdoc_name = name
  end

  # @return [Array<String>]
  def generics_declarations
    []
  end

  # :nocov:
  def to_s
    "Generic declaration #{@name}"
  end
  # :nocov:

end
