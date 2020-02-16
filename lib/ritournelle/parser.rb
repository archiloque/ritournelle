require_relative 'base_classes'
require_relative 'intermediate_representation'

require 'logger'

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
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
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

  VARIABLE_NAME = '[a-z_][a-z_\d]*'
  CLASS_NAME = '[A-Z][a-zA-Z\d]*'
  METHOD_NAME = '[a-z_][a-z_\d]*'
  PRIMITIVE_INT = '\d+'
  PRIMITIVE_FLOAT = '\d+\.\d*'
  GETTER = 'getter'
  SETTER = 'setter'
  RETURN = "\\Areturn "

  ASSIGN = "(?<name>@?#{VARIABLE_NAME}) = "
  METHOD_CALL = "(?<element>@?#{VARIABLE_NAME})\\.(?<method>#{METHOD_NAME})(?:\\((?<parameters>.*)\\))?\\z"

  def self.declaration_param(index)
    "(?<param_class_#{index}>#{CLASS_NAME}) (?<param_name_#{index}>#{VARIABLE_NAME})"
  end

  DECLARATION_PARAMETERS = "\\((#{declaration_param(0)}(, #{declaration_param(1)}(, #{declaration_param(2)}(, #{declaration_param(3)}(, #{declaration_param(4)})?)?)?)?)?\\)\\z"

  RX_DECLARE_VARIABLE = /\A(?<type>#{CLASS_NAME}) (?<name>#{VARIABLE_NAME})\z/

  RX_DECLARE_ABSTRACT_METHOD = /\Adef abstract (?<return_class>#{CLASS_NAME}) (?<name>#{METHOD_NAME})#{DECLARATION_PARAMETERS}/
  RX_DECLARE_METHOD = /\Adef (?<return_class>#{CLASS_NAME}) (?<name>#{METHOD_NAME})#{DECLARATION_PARAMETERS}/
  RX_DECLARE_CONSTRUCTOR = /\Adef constructor#{DECLARATION_PARAMETERS}/
  RX_DECLARE_CLASS = /\Aclass (?<name>#{CLASS_NAME})\z/
  RX_DECLARE_INTERFACE = /\Ainterface (?<name>#{CLASS_NAME})\z/

  RX_DECLARE_IMPLEMENTED_INTERFACE = /\Aimplements (?<type>#{CLASS_NAME})\z/
  RX_DECLARE_MEMBER = /\A(?<type>#{CLASS_NAME}) @(?<name>#{VARIABLE_NAME})(?<accessors>( #{GETTER}| #{SETTER}| #{GETTER} #{SETTER}| #{SETTER} #{GETTER})?)\z/

  RX_RETURN_VARIABLE_OR_MEMBER = /#{RETURN}(?<name>@?#{VARIABLE_NAME})\z/

  RX_ASSIGN_INTEGER = /\A#{ASSIGN}(?<value>#{PRIMITIVE_INT})\z/
  RX_RETURN_INTEGER = /#{RETURN}(?<value>#{PRIMITIVE_INT})\z/
  RX_DECLARE_ASSIGN_INTEGER = /\A(?<type>#{CLASS_NAME}) #{ASSIGN}(?<value>#{PRIMITIVE_INT})\z/

  RX_ASSIGN_FLOAT = /\A#{ASSIGN}(?<value>#{PRIMITIVE_FLOAT})\z/
  RX_RETURN_FLOAT = /#{RETURN}(?<value>#{PRIMITIVE_FLOAT})\z/
  RX_DECLARE_ASSIGN_FLOAT = /\A(?<type>#{CLASS_NAME}) #{ASSIGN}(?<value>#{PRIMITIVE_FLOAT})\z/

  RX_ASSIGN_VARIABLE_OR_MEMBER = /\A#{ASSIGN}(?<value>@?#{VARIABLE_NAME})\z/
  RX_DECLARE_ASSIGN_VARIABLE = /\A(?<type>#{CLASS_NAME}) #{ASSIGN}(?<value>@?#{VARIABLE_NAME})\z/

  RX_METHOD_CALL = /\A#{METHOD_CALL}/

  RX_RETURN_METHOD_CALL = /#{RETURN}#{METHOD_CALL}/

  RX_ASSIGN_METHOD_CALL = /\A#{ASSIGN}#{METHOD_CALL}/
  RX_DECLARE_VARIABLE_ASSIGN_METHOD_CALL = /\A(?<type>#{CLASS_NAME}) #{ASSIGN}#{METHOD_CALL}/

  RX_ASSIGN_CONSTRUCTOR_CALL = /\A#{ASSIGN}(?<class>#{CLASS_NAME})\.new\((?<parameters>.*)\)\z/
  RX_DECLARE_ASSIGN_CONSTRUCTOR_CALL = /\A(?<type>#{CLASS_NAME}) #{ASSIGN}(?<class>#{CLASS_NAME})\.new\((?<parameters>.*)\)\z/

  RX_PARAMETER_INT = /\A(?<value>#{PRIMITIVE_INT})\z/
  RX_PARAMETER_FLOAT = /\A(?<value>#{PRIMITIVE_FLOAT})\z/
  RX_END = /\Aend\z/

  RULES_IN_CODE = [
      {regex: RX_DECLARE_VARIABLE, method: :parse_declare_variable},
      {regex: RX_DECLARE_ASSIGN_VARIABLE, method: :parse_declare_assign_variable},

      {regex: RX_ASSIGN_INTEGER, method: :parse_assign_integer},
      {regex: RX_DECLARE_ASSIGN_INTEGER, method: :parse_declare_assign_integer},

      {regex: RX_ASSIGN_FLOAT, method: :parse_assign_float},
      {regex: RX_DECLARE_ASSIGN_FLOAT, method: :parse_declare_assign_float},

      {regex: RX_ASSIGN_VARIABLE_OR_MEMBER, method: :parse_assign_variable_or_member},

      {regex: RX_METHOD_CALL, method: :parse_method_call},

      {regex: RX_ASSIGN_METHOD_CALL, method: :parse_assign_method_call},
      {regex: RX_DECLARE_VARIABLE_ASSIGN_METHOD_CALL, method: :parse_declare_variable_assign_method_call},

      {regex: RX_ASSIGN_CONSTRUCTOR_CALL, method: :parse_assign_constructor_call},
      {regex: RX_DECLARE_ASSIGN_CONSTRUCTOR_CALL, method: :parse_declare_assign_constructor_call},
  ]

  RULES_FOR_IN_CLASS_CODE = RULES_IN_CODE.concat(
      [
          {regex: RX_END, method: :parse_end},
      ])

  PARSING_RULES = {
      Ritournelle::IntermediateRepresentation::World => RULES_IN_CODE.concat(
          [
              {regex: RX_DECLARE_CLASS, method: :parse_declare_class},
              {regex: RX_DECLARE_INTERFACE, method: :parse_declare_interface},
              {regex: RX_DECLARE_METHOD, method: :parse_declare_method},
          ]),
      Ritournelle::IntermediateRepresentation::ClassDeclaration => [
          {regex: RX_DECLARE_MEMBER, method: :parse_declare_member},
          {regex: RX_DECLARE_IMPLEMENTED_INTERFACE, method: :parse_declare_implemented_interfaces},
          {regex: RX_DECLARE_METHOD, method: :parse_declare_method},
          {regex: RX_DECLARE_CONSTRUCTOR, method: :parse_declare_constructor},
          {regex: RX_END, method: :parse_end},
      ],
      Ritournelle::IntermediateRepresentation::InterfaceDeclaration => [
          {regex: RX_DECLARE_ABSTRACT_METHOD, method: :parse_declare_abstract_method},
          {regex: RX_DECLARE_METHOD, method: :parse_declare_abstract_method},
          {regex: RX_END, method: :parse_end},
      ],
      Ritournelle::IntermediateRepresentation::MethodDeclaration => RULES_FOR_IN_CLASS_CODE.concat(
          [
              {regex: RX_RETURN_INTEGER, method: :parse_return_integer},
              {regex: RX_RETURN_FLOAT, method: :parse_return_float},
              {regex: RX_RETURN_VARIABLE_OR_MEMBER, method: :parse_return_variable_or_member},
              {regex: RX_RETURN_METHOD_CALL, method: :parse_return_method_call},
          ]),
      Ritournelle::IntermediateRepresentation::ConstructorDeclaration => RULES_FOR_IN_CLASS_CODE
  }

  def parse_next_line
    @logger.debug("Parsing [#{@line}] in context #{@stack.last.class}")
    if @line.empty?
    else
      parsed = PARSING_RULES[@stack.last.class].any? do |rule|
        if (m = rule[:regex].match(@line))
          @logger.debug("Matched for #{rule[:method]}")
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
  def parse_declare_variable(match)
    add_statement(Ritournelle::IntermediateRepresentation::Variable.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['type'],
        name: match['name'])
    )
  end

  # @param [MatchData] match
  def parse_return_variable_or_member(match)
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: match['name'],
        parent: @stack.last
    ))
  end

  # @param [MatchData] match
  def parse_assign_integer(match)
    parse_assign_primitive_value(
        name: match['name'],
        value: Integer(match['value']),
        clazz: world.classes_declarations[INT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_declare_assign_integer(match)
    parse_declare_variable(match)
    parse_assign_integer(match)
  end

  # @param [MatchData] match
  def parse_assign_variable_or_member(match)
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        name: match['name'],
        value: match['value'])
    )
  end

  # @param [MatchData] match
  def parse_declare_assign_variable(match)
    parse_declare_variable(match)
    parse_assign_variable_or_member(match)
  end

  # @param [MatchData] match
  def parse_return_integer(match)
    parse_return_primitive_value(
        value: Integer(match['value']),
        clazz: world.classes_declarations[INT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_assign_float(match)
    parse_assign_primitive_value(
        name: match['name'],
        value: Float(match['value']),
        clazz: world.classes_declarations[FLOAT_CLASS_NAME]
    )
  end

  # @param [MatchData] match
  def parse_declare_assign_float(match)
    parse_declare_variable(match)
    parse_assign_float(match)
  end

  # @param [MatchData] match
  def parse_return_float(match)
    parse_return_primitive_value(
        value: Float(match['value']),
        clazz: world.classes_declarations[FLOAT_CLASS_NAME])
  end

  # @param [String] name
  # @param [Integer|Float] value
  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] clazz
  def parse_assign_primitive_value(name:, value:, clazz:)
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
  def parse_return_primitive_value(value:, clazz:)
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
    call_parameters = process_method_call_parameters(match)
    add_statement(Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        element_name: match['element'],
        method_name: match['method'],
        parameters: call_parameters
    ))
  end

  # @param [MatchData] match
  def parse_declare_class(match)
    class_name = match['name']
    check_class_or_interface_don_t_exist(class_name)
    class_declaration = Ritournelle::IntermediateRepresentation::ClassDeclaration.new(
        file_path: @file_path,
        line_index: @line_index,
        name: class_name
    )
    add_statement(class_declaration)
    @world.classes_declarations[class_name] = class_declaration
    @stack << class_declaration
  end

  # @param [MatchData] match
  def parse_declare_interface(match)
    interface_name = match['name']
    check_class_or_interface_don_t_exist(interface_name)
    interface_declaration = Ritournelle::IntermediateRepresentation::InterfaceDeclaration.new(
        file_path: @file_path,
        line_index: @line_index,
        name: interface_name
    )
    add_statement(interface_declaration)
    @world.interfaces_declarations[interface_name] = interface_declaration
    @stack << interface_declaration
  end

  # @param [MatchData] match
  def parse_declare_member(match)
    short_name = match['name']
    name = "@#{short_name}"
    type = match['type']
    accessors = match['accessors'].split(' ').map(&:strip)
    getter = accessors.include?(GETTER)
    setter = accessors.include?(SETTER)
    member = Ritournelle::IntermediateRepresentation::MemberDeclaration.new(
        file_path: @file_path,
        line_index: @line_index,
        type: type,
        name: name,
    )
    add_statement(member)
    if getter
      method = Ritournelle::IntermediateRepresentation::MethodDeclaration.new(
          file_path: @file_path,
          line_index: @line_index,
          parent: @stack.last,
          declared_name: short_name,
          parameters_classes: [],
          parameters_names: [],
          return_class: type,
          method_index: @world.method_index(declared_name: short_name, parameters_classes: [])
      )
      add_statement(method)
      @stack.last.methods_declarations << method
      @stack << method
      add_statement(Ritournelle::IntermediateRepresentation::Return.new(
          file_path: @file_path,
          line_index: @line_index,
          value: name,
          parent: method
      ))
      @stack.pop
    end
    if setter
      method = Ritournelle::IntermediateRepresentation::MethodDeclaration.new(
          file_path: @file_path,
          line_index: @line_index,
          parent: @stack.last,
          declared_name: "#{short_name}=",
          parameters_classes: [type],
          parameters_names: [short_name],
          return_class: 'Void',
          method_index: @world.method_index(declared_name: "#{short_name}=", parameters_classes: [type])
      )
      add_statement(method)
      @stack.last.methods_declarations << method
      @stack << method
      add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
          file_path: @file_path,
          line_index: @line_index,
          name: name,
          value: short_name)
      )
      @stack.pop
    end
    @stack.last.members[name] = member
  end

  # @param [MatchData] match
  def parse_declare_implemented_interfaces(match)
    type = match['type']
    @stack.last.implemented_interfaces << type
  end

  # @param [MatchData] _
  def parse_end(_)
    @stack.pop
  end

  # @param [MatchData] match
  def parse_assign_method_call(match)
    call_parameters = process_method_call_parameters(match)
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        element_name: match['element'],
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
  def parse_declare_variable_assign_method_call(match)
    parse_declare_variable(match)
    parse_assign_method_call(match)
  end

  # @param [MatchData] match
  def parse_assign_constructor_call(match)
    call_parameters = process_method_call_parameters(match)
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
  def parse_declare_assign_constructor_call(match)
    parse_declare_variable(match)
    parse_assign_constructor_call(match)
  end


  # @param [MatchData] match
  def parse_return_method_call(match)
    call_parameters = process_method_call_parameters(match)
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        element_name: match['element'],
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
  def parse_declare_method(match)
    method_declaration = parse_declare_method_common(match, Ritournelle::IntermediateRepresentation::MethodDeclaration)
    add_statement(method_declaration)
    @stack.last.methods_declarations << method_declaration
    @stack << method_declaration
  end

  # @param [MatchData] match
  def parse_declare_abstract_method(match)
    method_declaration = parse_declare_method_common(match, Ritournelle::IntermediateRepresentation::AbstractMethodDeclaration)
    add_statement(method_declaration)
    @stack.last.abstract_methods_declarations << method_declaration
  end

  # @param [MatchData] match
  # @param [Class] method_class
  def parse_declare_method_common(match, method_class)
    return_class = match['return_class']
    name = match['name']
    number_of_parameters = ((match.captures.compact.length - 2) / 2)
    parameters_classes = []
    parameters_names = []
    0.upto(number_of_parameters - 1) do |parameter_index|
      parameters_classes << match["param_class_#{parameter_index}"]
      parameters_names << match["param_name_#{parameter_index}"]
    end
    method_class.new(
        file_path: @file_path,
        line_index: @line_index,
        parent: @stack.last,
        declared_name: name,
        parameters_classes: parameters_classes,
        parameters_names: parameters_names,
        return_class: return_class,
        method_index: @world.method_index(declared_name: name, parameters_classes: parameters_classes)
    )
  end

  # @param [MatchData] match
  def parse_declare_constructor(match)
    number_of_parameters = (match.captures.compact.length / 2)
    parameters_classes = []
    parameters_names = []
    0.upto(number_of_parameters - 1) do |parameter_index|
      parameters_classes << match["param_class_#{parameter_index}"]
      parameters_names << match["param_name_#{parameter_index}"]
    end
    constructor = Ritournelle::IntermediateRepresentation::ConstructorDeclaration.new(
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

  # @param [MatchData] match
  # @return [Array<String,Ritournelle::IntermediateRepresentation::ConstructorCall>]
  def process_method_call_parameters(match)
    if match['parameters'].nil?
      return []
    end

    match['parameters'].strip.split(',').collect do |call_parameter|
      c = call_parameter.strip
      if RX_PARAMETER_INT.match(c)
        Ritournelle::IntermediateRepresentation::ConstructorCall.new(
            file_path: @file_path,
            line_index: @line_index,
            parameters: [Integer(c)],
            type: world.classes_declarations[INT_CLASS_NAME].name
        )
      elsif RX_PARAMETER_FLOAT.match(c)
        Ritournelle::IntermediateRepresentation::ConstructorCall.new(
            file_path: @file_path,
            line_index: @line_index,
            parameters: [Float(c)],
            type: world.classes_declarations[FLOAT_CLASS_NAME].name
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

  # @param [String] name
  # @raise [RuntimeError]
  def check_class_or_interface_don_t_exist(name)
    if @world.interfaces_declarations.key?(name) || @world.classes_declarations.key?(name)
      raise_error("Class or interface [#{name}] already exists")
    end
  end

end
