require_relative '../ritournelle'
require_relative 'intermediate_representation'

class Ritournelle::Parser

  include Ritournelle::Keywords

  STATUS_NOWHERE = :nowhere

  # @return [Ritournelle::IntermediateRepresentation::World]
  attr_reader :world

  # @param [String] code
  def initialize(code)
    @world = Ritournelle::IntermediateRepresentation::World.new
    @stack = [@world]
    @status = STATUS_NOWHERE
    @splitted_code = code.split("\n")
    @line_index = -1
    while @line_index < (@splitted_code.length - 1)
      @line_index += 1
      fetch_current_line
      parse_next
    end
  end

  # Parse the next thing
  def parse_next
    case @status
    when STATUS_NOWHERE
      parse_next_nowhere
    else
      raise "Unknown status [#{@status}]"
    end
  end


  # Parse the next thing
  def parse_next_nowhere
    if @line.empty?
      @line_index += 1
      fetch_current_line
    elsif @line.start_with?(KEYWORD_CLASS)
      # Class declaration
      raise 'Not implemented'
    elsif /[[:upper:]]/.match(@line[0])
      # Variable declaration
      parse_variable
    else
      parse_assignment
    end
  end

  DECLARATION_REGEX = /\A(?<type>[A-Z][a-zA-Z]*) (?<name>[a-z_]+)\z/

  def parse_variable
    match = DECLARATION_REGEX.match(@line)
    unless match
      raise "Can't parse [#{@line}]"
    end
    add_statement(Ritournelle::IntermediateRepresentation::Variable.new(
        match['type'],
        match['name']))
  end


  INTEGER_ASSIGNMENT_REGEX = /\A(?<name>[a-z_]+) = (?<value>\d+)\z/

  def parse_assignment
    match = INTEGER_ASSIGNMENT_REGEX.match(@line)
    unless match
      raise "Can't parse [#{@line}]"
    end
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        match['value'])
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        match['name'],
        constructor_call))
  end

  def fetch_current_line
    @line = @splitted_code[@line_index]
    @column_index = @line.index(/\S/)
    @line.strip!
  end

  # @param [Object] statement
  def add_statement(statement)
    @stack.last.statements << statement
  end

end
