class Ritournelle::IntermediateRepresentation::Base

  # @return [String]
  attr_reader :file_path

  # @return [Integer]
  attr_reader :line_index

  # @param [String] file_path
  # @param [Integer] line_index
  def initialize(file_path:, line_index:)
    @file_path = file_path
    @line_index = line_index + 1
  end

  # @param [String] message
  # @raise [RuntimeError]
  def raise_error(message)
    raise RuntimeError, message, ["#{file_path}:#{line_index}"]
  end
end