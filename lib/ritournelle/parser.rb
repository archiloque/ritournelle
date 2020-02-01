require_relative 'base_classes'
require_relative 'intermediate_representation'

class Ritournelle::Parser

  include Ritournelle::Keywords
  include Ritournelle::BaseClasses

  CONTEXT_ROOT = :root
  CONTEXT_IN_CLASS = :in_class
  CONTEXT_IN_METHOD = :in_method

  # @return [Ritournelle::IntermediateRepresentation::World]
  attr_reader :world

  # @param [String] code
  # @param [String] file_path
  def initialize(code:, file_path:)
    @file_path = file_path
    @world = Ritournelle::IntermediateRepresentation::World.new
    @stack = [@world]
    @splitted_code = code.split("\n")
    @line_index = -1
    while @line_index < (@splitted_code.length - 1)
      @line_index += 1
      fetch_current_line
      parse_next_line
    end
  end

  REGEX_MATCH_VARIABLE_NAME = '[a-z_]+'
  REGEX_MATCH_CLASS_NAME = '[A-Z][a-zA-Z]*'
  REGEX_MATCH_METHOD_NAME = '[a-z_]+'
  REGEX_MATCH_PRIMITIVE_INT = '\d+'
  REGEX_MATCH_PRIMITIVE_FLOAT = '\d+\.\d*'

  REGEX_VARIABLE_DECLARATION = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) (?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_VARIABLE_RETURN = /\Areturn (?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_CLASS_MEMBER = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) @(?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_INTEGER_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_INTEGER_RETURN = /\Areturn (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_FLOAT_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_FLOAT_RETURN = /\Areturn (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_METHOD_CALL = /\A(?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_METHOD_CALL_RETURN = /\Areturn (?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_METHOD_CALL_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_PARAMETER_INT = /\A(?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_PARAMETER_FLOAT = /\A(?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_CLASS_DECLARATION = /\Aclass (?<class>#{REGEX_MATCH_CLASS_NAME})\z/
  REGEX_METHOD_DECLARATION = /\Adef (?<return_class>#{REGEX_MATCH_CLASS_NAME}) (?<name>#{REGEX_MATCH_VARIABLE_NAME})\(((?<parameter_class_0>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_0>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_1>#{REGEX_MATCH_CLASS_NAME}) (?< parameter_name_1>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_2>#{REGEX_MATCH_CLASS_NAME}) (?< parameter_name_2>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_3>#{REGEX_MATCH_CLASS_NAME}) (?< parameter_name_3>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_4>#{REGEX_MATCH_CLASS_NAME}) (?< parameter_name_4>#{REGEX_MATCH_VARIABLE_NAME}))?)?)?)?)?\)\z/
  REGEX_END = /\Aend\z/

  PARSING_RULES = {
      Ritournelle::IntermediateRepresentation::World => [
          {
              regex: REGEX_VARIABLE_DECLARATION,
              method: :parse_variable_declaration
          },
          {
              regex: REGEX_INTEGER_ASSIGNMENT,
              method: :parse_integer_assignment
          },
          {
              regex: REGEX_FLOAT_ASSIGNMENT,
              method: :parse_float_assignment
          },
          {
              regex: REGEX_METHOD_CALL,
              method: :parse_method_call
          },
          {
              regex: REGEX_METHOD_CALL_ASSIGNMENT,
              method: :parse_method_call_assignment
          },
          {
              regex: REGEX_CLASS_DECLARATION,
              method: :parse_class_declaration
          },
          {
              regex: REGEX_METHOD_DECLARATION,
              method: :parse_method_declaration
          }
      ],
      Ritournelle::IntermediateRepresentation::Class => [
          {
              regex: REGEX_CLASS_MEMBER,
              method: :parse_class_member
          },
          {
              regex: REGEX_END,
              method: :parse_end
          },
          {
              regex: REGEX_METHOD_DECLARATION,
              method: :parse_method_declaration
          }
      ],
      Ritournelle::IntermediateRepresentation::Method => [
          {
              regex: REGEX_VARIABLE_DECLARATION,
              method: :parse_variable_declaration
          },
          {
              regex: REGEX_INTEGER_ASSIGNMENT,
              method: :parse_integer_assignment
          },
          {
              regex: REGEX_INTEGER_RETURN,
              method: :parse_integer_return
          },
          {
              regex: REGEX_FLOAT_ASSIGNMENT,
              method: :parse_float_assignment
          },
          {
              regex: REGEX_FLOAT_RETURN,
              method: :parse_float_return
          },
          {
              regex: REGEX_METHOD_CALL,
              method: :parse_method_call
          },
          {
              regex: REGEX_METHOD_CALL_ASSIGNMENT,
              method: :parse_method_call_assignment
          },
          {
              regex: REGEX_VARIABLE_RETURN,
              method: :parse_variable_return
          },
          {
              regex: REGEX_METHOD_CALL_RETURN,
              method: :parse_method_call_return
          },
          {
              regex: REGEX_END,
              method: :parse_end
          }
      ]
  }

  def parse_next_line
    puts "Parsing [#{@line}] in context #{@stack.last.class}"
    if @line.empty?
    else
      parsed = PARSING_RULES[@stack.last.class].any? do |rule|
        if (m = rule[:regex].match(@line))
          puts "Matched for #{rule[:method]}"
          send(rule[:method], m)
          true
        end
      end
      unless parsed
        raise "Can't parse [#{@line}] in context #{@stack.last.class}"
      end
    end
  end

  # @param [MatchData] match
  def parse_variable_declaration(match)
    add_statement(Ritournelle::IntermediateRepresentation::Variable.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['type'],
        name: match['name'])
    )
  end

  # @param [MatchData] match
  def parse_variable_return(match)
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: match['name'],
        parent: @stack.last
    ))
  end

  # @param [MatchData] match
  def parse_integer_assignment(match)
    parse_primitive_assignment(
        name: match['name'],
        value: Integer(match['value']),
        clazz: world.clazzez[INT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_integer_return(match)
    parse_primitive_return(
        value: Integer(match['value']),
        clazz: world.clazzez[INT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_float_assignment(match)
    parse_primitive_assignment(
        name: match['name'],
        value: Float(match['value']),
        clazz: world.clazzez[FLOAT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_float_return(match)
    parse_primitive_return(
        value: Float(match['value']),
        clazz: world.clazzez[FLOAT_CLASS_NAME])
  end

  # @param [String] name
  # @param [Integer|Float] value
  # @param [Ritournelle::IntermediateRepresentation::Class] clazz
  def parse_primitive_assignment(name:, value:, clazz:)
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        parameters: [value],
        parent: clazz
    )
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        name: name,
        value: constructor_call)
    )
  end

  # @param [Integer|Float] value
  def parse_primitive_return(value:, clazz:)
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        parameters: [value],
        parent: clazz
    )
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: constructor_call,
        parent: @stack.last)
    )
  end

  # @param [MatchData] match
  def parse_method_call(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    add_statement(Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        variable_name: match['variable'],
        method_name: match['method'],
        parameters: call_parameters
    ))
  end

  # @param [MatchData] match
  def parse_class_declaration(match)
    class_name = match['class']
    clazz = Ritournelle::IntermediateRepresentation::Class.new(
        file_path: @file_path,
        line_index: @line_index,
        name: class_name
    )
    add_statement(clazz)
    @world.clazzez[class_name] = clazz
    @stack << clazz
  end

  # @param [MatchData] match
  def parse_class_member(match)
    name = match['name']
    @stack.last.members[name] = Ritournelle::IntermediateRepresentation::Member.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['type'],
        name: name
    )
  end

  # @param [MatchData] _
  def parse_end(_)
    @stack.pop
  end

  # @param [MatchData] match
  def parse_method_call_assignment(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        variable_name: match['variable'],
        method_name: match['method'],
        parameters: call_parameters
    )
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        name: match['name'],
        value: method_call)
    )
  end

  # @param [MatchData] match
  def parse_method_call_return(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        variable_name: match['variable'],
        method_name: match['method'],
        parameters: call_parameters
    )
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: method_call,
        parent: @stack.last
    ))
  end

  # @param [MatchData] match
  def parse_method_declaration(match)
    return_class = match['return_class']
    name = match['name']
    number_of_parameters = ((match.captures.compact.length - 2) / 2)
    parameters_classes = []
    parameters_names = []
    0.upto(number_of_parameters - 1) do |parameter_index|
      parameters_classes << match["parameter_class_#{parameter_index}"]
      parameters_names << match["parameter_name_#{parameter_index}"]
    end
    method = Ritournelle::IntermediateRepresentation::Method.new(
        file_path: @file_path,
        line_index: @line_index,
        parent: @stack.last,
        declared_name: name,
        parameters_classes: parameters_classes,
        parameters_names: parameters_names,
        return_class: return_class
    )
    add_statement(method)
    @stack.last.methodz << method
    @stack << method
  end


  def fetch_current_line
    @line = @splitted_code[@line_index]
    @column_index = @line.index(/\S/)
    @line.strip!
  end

  # @param [Ritournelle::IntermediateRepresentation::Base] statement
  def add_statement(statement)
    @stack.last.statements << statement
  end

  private

  # @param [String] call_parameters
  # @return [Array<String,Ritournelle::IntermediateRepresentation::ConstructorCall>]
  def process_method_call_parameters(call_parameters)
    call_parameters.strip.split(',').collect do |call_parameter|
      c = call_parameter.strip
      if REGEX_PARAMETER_INT.match(c)
        Ritournelle::IntermediateRepresentation::ConstructorCall.new(
            file_path: @file_path,
            line_index: @line_index,
            parameters: [Integer(c)],
            parent: world.clazzez[INT_CLASS_NAME]
        )
      elsif REGEX_PARAMETER_FLOAT.match(c)
        Ritournelle::IntermediateRepresentation::ConstructorCall.new(
            file_path: @file_path,
            line_index: @line_index,
            parameters: [Float(c)],
            parent: world.clazzez[FLOAT_CLASS_NAME]
        )
      else
        c
      end
    end
  end

  # @param [Class] clazz
  # @return [String]
  def self.class_name(clazz)
    clazz.name.split('::').last
  end

end
