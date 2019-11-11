require_relative 'intermediate_representation'

class Ritournelle::Parser

  include Ritournelle::Keywords

  CONTEXT_ROOT = :root
  CONTEXT_IN_CLASS = :in_class

  # @return [Ritournelle::IntermediateRepresentation::World]
  attr_reader :world

  # @param [String] code
  def initialize(code)
    @world = Ritournelle::IntermediateRepresentation::World.new
    @stack = [@world]
    @context = CONTEXT_ROOT
    @splitted_code = code.split("\n")
    @line_index = -1
    while @line_index < (@splitted_code.length - 1)
      @line_index += 1
      fetch_current_line
      parse_next_line
    end
  end

  REGEX_MATCH_VARIABLE = '[a-z_]+'
  REGEX_MATCH_CLASS_NAME = '[A-Z][a-zA-Z]*'
  REGEX_MATCH_METHOD_NAME = '[a-z_]+'
  REGEX_MATCH_PRIMITIVE_INT = '\d+'
  REGEX_MATCH_PRIMITIVE_FLOAT = '\d+\.\d*'

  REGEX_VARIABLE = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) (?<name>#{REGEX_MATCH_VARIABLE})\z/
  REGEX_CLASS_MEMBER = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) @(?<name>#{REGEX_MATCH_VARIABLE})\z/
  REGEX_INTEGER_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE}) = (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_FLOAT_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE}) = (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_METHOD_CALL = /\A(?<variable>#{REGEX_MATCH_VARIABLE})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_METHOD_CALL_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE}) = (?<variable>#{REGEX_MATCH_VARIABLE})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_PARAMETER_INT = /\A(?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_CLASS_DECLARATION = /\Aclass (?<class>#{REGEX_MATCH_CLASS_NAME})\z/
  REGEX_END = /\Aend\z/

  PARSING_RULES = {
      CONTEXT_ROOT => [
          {
              regex: REGEX_VARIABLE,
              code: :parse_variable
          },
          {
              regex: REGEX_INTEGER_ASSIGNMENT,
              code: :parse_integer_assignment
          },
          {
              regex: REGEX_FLOAT_ASSIGNMENT,
              code: :parse_float_assignment
          },
          {
              regex: REGEX_METHOD_CALL,
              code: :parse_method_call
          },
          {
              regex: REGEX_METHOD_CALL_ASSIGNMENT,
              code: :parse_method_call_assignment
          },
          {
              regex: REGEX_CLASS_DECLARATION,
              code: :parse_class_declaration
          },
      ], CONTEXT_IN_CLASS => [
          {
              regex: REGEX_CLASS_MEMBER,
              code: :parse_class_member
          },
          {
              regex: REGEX_END,
              code: :parse_class_end
          },
      ]
  }

  def parse_next_line
    STDOUT << "Parsing [#{@line}] in context #{@context}\n"
    if @line.empty?
    else
      parsed = PARSING_RULES[@context].any? do |rule|
        if (m = rule[:regex].match(@line))
          STDOUT << "Matched for #{rule[:code]}\n"
          send(rule[:code], m)
          true
        end
      end
      unless parsed
        raise "Can't parse [#{@line}] in context #{@context}"
      end
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

  # @param [MatchData] match
  def parse_class_declaration(match)
    class_name = match['class']
    clazz = Ritournelle::IntermediateRepresentation::Class.new(
        class_name
    )
    @world.classes[class_name] = clazz
    add_statement(clazz)
    @context = CONTEXT_IN_CLASS
    @stack << clazz
  end

  # @param [MatchData] match
  def parse_class_member(match)
    name = match['name']
    @stack.last.members[name] = Ritournelle::IntermediateRepresentation::Member.new(
        match['type'],
        name)
  end

  # @param [MatchData] _
  def parse_class_end(_)
    @context = CONTEXT_ROOT
    @stack.pop
  end

  # @param [MatchData] match
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
      if REGEX_PARAMETER_INT.match(c)
        c.to_i
      else
        c
      end
    end
  end

end
