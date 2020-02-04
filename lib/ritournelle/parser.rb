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

  private

  REGEX_MATCH_VARIABLE_NAME = '[a-z_][a-z_\d]*'
  REGEX_MATCH_CLASS_NAME = '[A-Z][a-zA-Z\d]*'
  REGEX_MATCH_METHOD_NAME = '[a-z_][a-z_\d]*'
  REGEX_MATCH_PRIMITIVE_INT = '\d+'
  REGEX_MATCH_PRIMITIVE_FLOAT = '\d+\.\d*'

  REGEX_VARIABLE_DECLARATION = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) (?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/

  REGEX_METHOD_DECLARATION = /\Adef (?<return_class>#{REGEX_MATCH_CLASS_NAME}) (?<name>#{REGEX_MATCH_METHOD_NAME})\(((?<parameter_class_0>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_0>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_1>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_1>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_2>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_2>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_3>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_3>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_4>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_4>#{REGEX_MATCH_VARIABLE_NAME}))?)?)?)?)?\)\z/
  REGEX_CONSTRUCTOR_DECLARATION = /\Adef constructor\(((?<parameter_class_0>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_0>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_1>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_1>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_2>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_2>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_3>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_3>#{REGEX_MATCH_VARIABLE_NAME})(, (?<parameter_class_4>#{REGEX_MATCH_CLASS_NAME}) (?<parameter_name_4>#{REGEX_MATCH_VARIABLE_NAME}))?)?)?)?)?\)\z/
  REGEX_CLASS_DECLARATION = /\Aclass (?<class>#{REGEX_MATCH_CLASS_NAME})\z/
  REGEX_CLASS_MEMBER_DECLARATION = /\A(?<type>#{REGEX_MATCH_CLASS_NAME}) @(?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/

  REGEX_VARIABLE_RETURN = /\Areturn (?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_MEMBER_RETURN = /\Areturn @(?<name>#{REGEX_MATCH_VARIABLE_NAME})\z/

  REGEX_INTEGER_TO_VARIABLE_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_INTEGER_TO_MEMBER_ASSIGNMENT = /\A@(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_INTEGER_RETURN = /\Areturn (?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/

  REGEX_FLOAT_TO_VARIABLE_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_FLOAT_TO_MEMBER_ASSIGNMENT = /\A@(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_FLOAT_RETURN = /\Areturn (?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/

  REGEX_VARIABLE_TO_VARIABLE_ASSIGNMENT = /\A(?<name1>#{REGEX_MATCH_VARIABLE_NAME}) = (?<name2>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_VARIABLE_TO_MEMBER_ASSIGNMENT = /\A@(?<name1>#{REGEX_MATCH_VARIABLE_NAME}) = (?<name2>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_MEMBER_TO_VARIABLE_ASSIGNMENT = /\A(?<name1>#{REGEX_MATCH_VARIABLE_NAME}) = @(?<name2>#{REGEX_MATCH_VARIABLE_NAME})\z/
  REGEX_MEMBER_TO_MEMBER_ASSIGNMENT = /\A@(?<name1>#{REGEX_MATCH_VARIABLE_NAME}) = @(?<name2>#{REGEX_MATCH_VARIABLE_NAME})\z/

  REGEX_METHOD_CALL = /\A(?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_METHOD_CALL_RETURN = /\Areturn (?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/
  REGEX_METHOD_CALL_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<variable>#{REGEX_MATCH_VARIABLE_NAME})\.(?<method>#{REGEX_MATCH_METHOD_NAME})\((?<parameters>.*)\)\z/

  REGEX_CONSTRUCTOR_CALL_TO_VARIABLE_ASSIGNMENT = /\A(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<class>#{REGEX_MATCH_CLASS_NAME})\.new\((?<parameters>.*)\)\z/
  REGEX_CONSTRUCTOR_CALL_TO_MEMBER_ASSIGNMENT = /\A@(?<name>#{REGEX_MATCH_VARIABLE_NAME}) = (?<class>#{REGEX_MATCH_CLASS_NAME})\.new\((?<parameters>.*)\)\z/

  REGEX_PARAMETER_INT = /\A(?<value>#{REGEX_MATCH_PRIMITIVE_INT})\z/
  REGEX_PARAMETER_FLOAT = /\A(?<value>#{REGEX_MATCH_PRIMITIVE_FLOAT})\z/
  REGEX_END = /\Aend\z/

  RULES_IN_CODE = [
      {regex: REGEX_VARIABLE_DECLARATION, method: :parse_variable_declaration},
      {regex: REGEX_INTEGER_TO_VARIABLE_ASSIGNMENT, method: :parse_integer_to_variable_assignment},
      {regex: REGEX_FLOAT_TO_VARIABLE_ASSIGNMENT, method: :parse_float_to_variable_assignment},
      {regex: REGEX_VARIABLE_TO_VARIABLE_ASSIGNMENT, method: :parse_variable_to_variable_assignment},
      {regex: REGEX_METHOD_CALL, method: :parse_method_call},
      {regex: REGEX_METHOD_CALL_ASSIGNMENT, method: :parse_method_call_assignment},
      {regex: REGEX_CONSTRUCTOR_CALL_TO_VARIABLE_ASSIGNMENT, method: :parse_constructor_call_to_variable_assignment},
  ]

  RULES_FOR_IN_CLASS_CODE = RULES_IN_CODE.concat(
      [
          {regex: REGEX_INTEGER_TO_MEMBER_ASSIGNMENT, method: :parse_integer_to_member_assignment},
          {regex: REGEX_FLOAT_TO_MEMBER_ASSIGNMENT, method: :parse_float_to_member_assignment},
          {regex: REGEX_CONSTRUCTOR_CALL_TO_MEMBER_ASSIGNMENT, method: :parse_constructor_call_to_member_assignment},
          {regex: REGEX_VARIABLE_TO_MEMBER_ASSIGNMENT, method: :parse_variable_to_member_assignment},
          {regex: REGEX_MEMBER_TO_VARIABLE_ASSIGNMENT, method: :parse_member_to_variable_assignment},
          {regex: REGEX_MEMBER_TO_MEMBER_ASSIGNMENT, method: :parse_member_to_member_assignment},
          {regex: REGEX_END, method: :parse_end},
      ])

  PARSING_RULES = {
      Ritournelle::IntermediateRepresentation::World => RULES_IN_CODE.concat(
          [
              {regex: REGEX_CLASS_DECLARATION, method: :parse_class_declaration},
              {regex: REGEX_METHOD_DECLARATION, method: :parse_method_declaration},
          ]),
      Ritournelle::IntermediateRepresentation::Class => [
          {regex: REGEX_CLASS_MEMBER_DECLARATION, method: :parse_class_member_declaration},
          {regex: REGEX_METHOD_DECLARATION, method: :parse_method_declaration},
          {regex: REGEX_CONSTRUCTOR_DECLARATION, method: :parse_constructor_declaration},
          {regex: REGEX_END, method: :parse_end},
      ],
      Ritournelle::IntermediateRepresentation::Method => RULES_FOR_IN_CLASS_CODE.concat(
          [
              {regex: REGEX_FLOAT_RETURN, method: :parse_float_return},
              {regex: REGEX_VARIABLE_RETURN, method: :parse_variable_return},
              {regex: REGEX_MEMBER_RETURN, method: :parse_member_return},
              {regex: REGEX_METHOD_CALL_RETURN, method: :parse_method_call_return},
              {regex: REGEX_INTEGER_RETURN, method: :parse_integer_return},
              {regex: REGEX_FLOAT_RETURN, method: :parse_float_return},
          ]),
      Ritournelle::IntermediateRepresentation::Constructor => RULES_FOR_IN_CLASS_CODE
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
        raise_error "Can't parse [#{@line}] in context #{@stack.last.class}"
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
  def parse_member_return(match)
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: "@#{match['name']}",
        parent: @stack.last
    ))
  end

  # @param [MatchData] match
  def parse_integer_to_variable_assignment(match)
    parse_primitive_assignment(
        name: match['name'],
        value: Integer(match['value']),
        clazz: world.clazzez[INT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_variable_to_variable_assignment(match)
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        name: match['name1'],
        value: match['name2'])
    )
  end

  # @param [MatchData] match
  def parse_variable_to_member_assignment(match)
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        name: "@#{match['name1']}",
        value: match['name2'])
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
  def parse_float_to_variable_assignment(match)
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
        type: clazz.name
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
        type: clazz.name
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
  def parse_class_member_declaration(match)
    name = "@#{match['name']}"
    member = Ritournelle::IntermediateRepresentation::Member.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['type'],
        name: name
    )
    add_statement(member)
    @stack.last.members[name] = member
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
  def parse_constructor_call_to_variable_assignment(match)
    call_parameters = process_method_call_parameters(match['parameters'])
    method_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['class'],
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

  # @param [MatchData] match
  def parse_constructor_declaration(match)
    number_of_parameters = (match.captures.compact.length / 2)
    parameters_classes = []
    parameters_names = []
    0.upto(number_of_parameters - 1) do |parameter_index|
      parameters_classes << match["parameter_class_#{parameter_index}"]
      parameters_names << match["parameter_name_#{parameter_index}"]
    end
    constructor = Ritournelle::IntermediateRepresentation::Constructor.new(
        file_path: @file_path,
        line_index: @line_index,
        parent: @stack.last,
        parameters_classes: parameters_classes,
        parameters_names: parameters_names,
    )
    add_statement(constructor)
    @stack.last.constructors << constructor
    @stack << constructor
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
            type: world.clazzez[INT_CLASS_NAME].name
        )
      elsif REGEX_PARAMETER_FLOAT.match(c)
        Ritournelle::IntermediateRepresentation::ConstructorCall.new(
            file_path: @file_path,
            line_index: @line_index,
            parameters: [Float(c)],
            type: world.clazzez[FLOAT_CLASS_NAME].name
        )
      else
        c
      end
    end
  end

  # @param [String] message
  # @raise [RuntimeError]
  def raise_error(message)
    raise RuntimeError, message, ["#{@file_path}:#{@line_index}"]
  end

end
