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

  VARIABLE_REGEX_MATCH = '[a-z_]+'
  CLASS_NAME_REGEX_MATCH = '[A-Z][a-zA-Z]*'
  METHOD_NAME_REGEX_MATCH = '[a-z_]+'
  PRIMITIVE_INT_REGEX_MATCH = '\d+'
  PRIMITIVE_FLOAT_REGEX_MATCH = '\d+\.\d*'

  DECLARATION_REGEX = /\A(?<type>#{CLASS_NAME_REGEX_MATCH}) (?<name>#{VARIABLE_REGEX_MATCH})\z/
  INTEGER_ASSIGNMENT_REGEX = /\A(?<name>#{VARIABLE_REGEX_MATCH}) = (?<value>#{PRIMITIVE_INT_REGEX_MATCH})\z/
  FLOAT_ASSIGNMENT_REGEX = /\A(?<name>#{VARIABLE_REGEX_MATCH}) = (?<value>#{PRIMITIVE_FLOAT_REGEX_MATCH})\z/
  METHOD_CALL_REGEX = /\A(?<variable>#{VARIABLE_REGEX_MATCH})\.(?<method>#{METHOD_NAME_REGEX_MATCH})\((?<parameters>.*)\)\z/
  METHOD_CALL_ASSIGNMENT_REGEX = /\A(?<name>#{VARIABLE_REGEX_MATCH}) = (?<variable>#{VARIABLE_REGEX_MATCH})\.(?<method>#{METHOD_NAME_REGEX_MATCH})\((?<parameters>.*)\)\z/
  PARAMETER_INT_REGEX = /\A(?<value>#{PRIMITIVE_INT_REGEX_MATCH})\z/

  def parse_next_nowhere
    if @line.empty?
      @line_index += 1
      fetch_current_line
    elsif @line.start_with?(KEYWORD_CLASS)
      # Class declaration
      raise 'Not implemented'
    elsif (m = DECLARATION_REGEX.match(@line))
      # Variable declaration
      parse_variable(m)
    elsif (m = INTEGER_ASSIGNMENT_REGEX.match(@line))
      parse_integer_assignment(m)
    elsif (m = FLOAT_ASSIGNMENT_REGEX.match(@line))
      parse_float_assignment(m)
    elsif (m = METHOD_CALL_REGEX.match(@line))
      parse_method_call(m)
    elsif (m = METHOD_CALL_ASSIGNMENT_REGEX.match(@line))
      parse_method_call_assignment(m)
    else
      raise "Can't parse [#{@line}]"
    end
  end

  # @param [MatchData] match
  def parse_variable(match)
    add_statement(Ritournelle::IntermediateRepresentation::Variable.new(
        match['type'],
        match['name']))
  end

  # @param [MatchData] match
  def parse_integer_assignment(match)
    parse_primitive_assignment(match['name'], Integer(match['value']))
  end

  # @param [MatchData] match
  def parse_float_assignment(match)
    parse_primitive_assignment(match['name'], Float(match['value']))
  end

  # @param [String] name
  # @param [Integer|Float] value
  def parse_primitive_assignment(name, value)
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        [value])
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        name,
        constructor_call))
  end

  # @param [MatchData] match
  def parse_method_call(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    add_statement(Ritournelle::IntermediateRepresentation::MethodCall.new(
        match['variable'],
        match['method'],
        call_parameters
    ))
  end

  def parse_method_call_assignment(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        match['variable'],
        match['method'],
        call_parameters
    )
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        match['name'],
        method_call))
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

  private

  def process_method_call_parameters(call_parameters)
    call_parameters.strip.split(',').collect do |call_parameter|
      c = call_parameter.strip
      if PARAMETER_INT_REGEX.match(c)
        c.to_i
      else
        c
      end
    end
  end

end
