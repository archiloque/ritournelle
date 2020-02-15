class Ritournelle::IntermediateRepresentation::Class < Ritournelle::IntermediateRepresentation::Base

  include Ritournelle::IntermediateRepresentation::WithStatements

  # @return [String]
  attr_reader :name

  # @return [String]
  attr_reader :rdoc_name

  # @return [Array<Ritournelle::IntermediateRepresentation::Constructor>]
  attr_reader :constructors

  # @return [Array<Ritournelle::IntermediateRepresentation::Method>]
  attr_reader :methodz

  # @return [Hash{String=>Ritournelle::IntermediateRepresentation::Method}]
  attr_reader :members

  # @param [String] file_path
  # @param [Integer] line_index
  # @param [String] name
  def initialize(file_path:, line_index:, name:, rdoc_name: name)
    super(file_path: file_path, line_index: line_index)
    @name = name
    @rdoc_name = rdoc_name
    @constructors = []
    @methodz = []
    @members = {}
  end

  # :nocov:
  def to_s
    "Class #{@name}"
  end
  # :nocov:

end
