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
  PRIMITIVE_INT = '-?\d+'
  PRIMITIVE_FLOAT = '-?\d+\.\d*'
  PRIMITIVE_BOOLEAN = 'true|false'
  GETTER = 'getter'
  SETTER = 'setter'
  RETURN = "\\Areturn "
  IF = "\\Aif "

  ASSIGN = "(?<name>@?#{VARIABLE_NAME}) = "
  METHOD_CALL = "(?<element>@?#{VARIABLE_NAME})\\.(?<method>#{METHOD_NAME})(?:\\((?<parameters>.*)\\))?\\z"
  GENERICS_LIST = "(<(?<generics>(:?#{CLASS_NAME}, *)*)(?<last_generic>#{CLASS_NAME})>)?"

  def self.declaration_param(index)
    "(?<param_class_#{index}>#{CLASS_NAME}) (?<param_name_#{index}>#{VARIABLE_NAME})"
  end

  # @param [String] type_regex
  # @return [Regexp]
  def self.assign_regex(type_regex)
    /\A#{ASSIGN}(?<value>#{type_regex})\z/
  end

  # @param [String] type_regex
  # @return [Regexp]
  def self.return_regex(type_regex)
    /#{RETURN}(?<value>#{type_regex})\z/
  end

  # @param [String] type_regex
  # @return [Regexp]
  def self.declare_assign_regex(type_regex)
    /\A(?<type>#{CLASS_NAME})#{GENERICS_LIST} #{ASSIGN}(?<value>#{type_regex})\z/
  end

  # @param [String] type_regex
  # @return [Regexp]
  def self.if_regex(type_regex)
    /#{IF}(?<value>#{type_regex})\z/
  end

  DECLARATION_PARAMETERS = "\\((#{declaration_param(0)}(, #{declaration_param(1)}(, #{declaration_param(2)}(, #{declaration_param(3)}(, #{declaration_param(4)})?)?)?)?)?\\)\\z"

  RX_DECLARE_VARIABLE = /\A(?<type>#{CLASS_NAME})#{GENERICS_LIST} (?<name>#{VARIABLE_NAME})\z/

  RX_DECLARE_ABSTRACT_METHOD = /\Adef abstract (?<return_class>#{CLASS_NAME}) (?<name>#{METHOD_NAME})#{DECLARATION_PARAMETERS}/
  RX_DECLARE_METHOD = /\Adef (?<return_class>#{CLASS_NAME}) (?<name>#{METHOD_NAME})#{DECLARATION_PARAMETERS}/
  RX_DECLARE_CONSTRUCTOR = /\Adef #{KEYWORD_CONSTRUCTOR}#{DECLARATION_PARAMETERS}/
  RX_DECLARE_CLASS = /\Aclass (?<name>#{CLASS_NAME})#{GENERICS_LIST}\z/
  RX_DECLARE_INTERFACE = /\Ainterface (?<name>#{CLASS_NAME})\z/

  RX_DECLARE_IMPLEMENTED_INTERFACE = /\Aimplements (?<type>#{CLASS_NAME})\z/
  RX_DECLARE_MEMBER = /\A(?<type>#{CLASS_NAME}) @(?<name>#{VARIABLE_NAME})(?<accessors>( #{GETTER}| #{SETTER}| #{GETTER} #{SETTER}| #{SETTER} #{GETTER})?)\z/

  RX_ASSIGN_INTEGER = assign_regex(PRIMITIVE_INT)
  RX_RETURN_INTEGER = return_regex(PRIMITIVE_INT)
  RX_DECLARE_ASSIGN_INTEGER = declare_assign_regex(PRIMITIVE_INT)

  RX_ASSIGN_FLOAT = assign_regex(PRIMITIVE_FLOAT)
  RX_RETURN_FLOAT = return_regex(PRIMITIVE_FLOAT)
  RX_DECLARE_ASSIGN_FLOAT = declare_assign_regex(PRIMITIVE_FLOAT)

  RX_ASSIGN_BOOLEAN = assign_regex(PRIMITIVE_BOOLEAN)
  RX_RETURN_BOOLEAN = return_regex(PRIMITIVE_BOOLEAN)
  RX_DECLARE_ASSIGN_BOOLEAN = declare_assign_regex(PRIMITIVE_BOOLEAN)

  RX_ASSIGN_VARIABLE_OR_MEMBER = assign_regex("@?#{VARIABLE_NAME}")
  RX_RETURN_VARIABLE_OR_MEMBER = return_regex("@?#{VARIABLE_NAME}")
  RX_DECLARE_ASSIGN_VARIABLE = declare_assign_regex("@?#{VARIABLE_NAME}")

  RX_METHOD_CALL = /\A#{METHOD_CALL}/
  RX_SETTER_CALL = /\A(?<element>@?#{VARIABLE_NAME})\.(?<method>#{METHOD_NAME})\ ?=\ ?(?:(?<parameters>.*))?\z/

  RX_RETURN_METHOD_CALL = /#{RETURN}#{METHOD_CALL}/

  RX_ASSIGN_METHOD_CALL = /\A#{ASSIGN}#{METHOD_CALL}/
  RX_DECLARE_VARIABLE_ASSIGN_METHOD_CALL = /\A(?<type>#{CLASS_NAME})#{GENERICS_LIST} #{ASSIGN}#{METHOD_CALL}/

  RX_ASSIGN_CONSTRUCTOR_CALL = /\A#{ASSIGN}(?<class>#{CLASS_NAME})#{GENERICS_LIST}\.new\((?<parameters>.*)\)\z/
  RX_DECLARE_ASSIGN_CONSTRUCTOR_CALL = /\A(?<type>#{CLASS_NAME})#{GENERICS_LIST} #{ASSIGN}(?<class>#{CLASS_NAME})#{GENERICS_LIST}\.new\((?<parameters>.*)\)\z/

  RX_PARAMETER_INT = /\A(?<value>#{PRIMITIVE_INT})\z/
  RX_PARAMETER_FLOAT = /\A(?<value>#{PRIMITIVE_FLOAT})\z/
  RX_PARAMETER_BOOLEAN = /\A(?<value>#{PRIMITIVE_BOOLEAN})\z/

  RX_IF_VARIABLE_OR_MEMBER = if_regex("@?#{VARIABLE_NAME}")
  RX_IF_METHOD_CALL = if_regex(METHOD_CALL)

  RX_END = /\Aend\z/

  RULES_IN_CODE = [
      {regex: RX_ASSIGN_INTEGER, method: :parse_assign_integer},
      {regex: RX_DECLARE_ASSIGN_INTEGER, method: :parse_declare_assign_integer},

      {regex: RX_ASSIGN_FLOAT, method: :parse_assign_float},
      {regex: RX_DECLARE_ASSIGN_FLOAT, method: :parse_declare_assign_float},

      {regex: RX_ASSIGN_BOOLEAN, method: :parse_assign_boolean},
      {regex: RX_DECLARE_ASSIGN_BOOLEAN, method: :parse_declare_assign_boolean},

      {regex: RX_DECLARE_VARIABLE, method: :parse_declare_variable},
      {regex: RX_DECLARE_ASSIGN_VARIABLE, method: :parse_declare_assign_variable},

      {regex: RX_ASSIGN_VARIABLE_OR_MEMBER, method: :parse_assign_variable_or_member},

      {regex: RX_METHOD_CALL, method: :parse_method_call},
      {regex: RX_SETTER_CALL, method: :parse_setter_call},

      {regex: RX_ASSIGN_METHOD_CALL, method: :parse_assign_method_call},
      {regex: RX_DECLARE_VARIABLE_ASSIGN_METHOD_CALL, method: :parse_declare_variable_assign_method_call},

      {regex: RX_ASSIGN_CONSTRUCTOR_CALL, method: :parse_assign_constructor_call},
      {regex: RX_DECLARE_ASSIGN_CONSTRUCTOR_CALL, method: :parse_declare_assign_constructor_call},

      {regex: RX_IF_VARIABLE_OR_MEMBER, method: :parse_if_variable_or_member},
      {regex: RX_IF_METHOD_CALL, method: :parse_if_method_call},
  ]

  RULES_FOR_IN_CLASS_CODE = RULES_IN_CODE.concat(
      [
          {regex: RX_END, method: :parse_end},
      ])

  RULES_FOR_IN_CONDITIONAL_EXPRESSION = RULES_IN_CODE.concat(
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
              {regex: RX_RETURN_BOOLEAN, method: :parse_return_boolean},
              {regex: RX_RETURN_VARIABLE_OR_MEMBER, method: :parse_return_variable_or_member},
              {regex: RX_RETURN_METHOD_CALL, method: :parse_return_method_call},
          ]),
      Ritournelle::IntermediateRepresentation::ConstructorDeclaration => RULES_FOR_IN_CLASS_CODE,
      Ritournelle::IntermediateRepresentation::ConditionalExpression => RULES_FOR_IN_CONDITIONAL_EXPRESSION
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
    generics = extract_generics(match)

    add_statement(
        Ritournelle::IntermediateRepresentation::VariableDeclaration.new(
            file_path: @file_path,
            line_index: @line_index,
            type: match['type'],
            name: match['name'],
            generics: generics
        )
    )
  end

  # @param [MatchData] match
  def parse_return_variable_or_member(match)
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: match['value'],
        parent: @stack.last,
        type: Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER
    ))
  end

  # @param [MatchData] match
  def parse_assign_integer(match)
    parse_assign_primitive_value(
        name: match['name'],
        value: Integer(match['value']),
        clazz: world.classes_declarations[INTEGER_CLASS_NAME],
        type: INTEGER_CLASS_NAME,
        match: match
    )
  end

  # @param [MatchData] match
  def parse_assign_float(match)
    parse_assign_primitive_value(
        name: match['name'],
        value: Float(match['value']),
        clazz: world.classes_declarations[FLOAT_CLASS_NAME],
        type:FLOAT_CLASS_NAME,
        match: match
    )
  end

  # @param [MatchData] match
  def parse_assign_boolean(match)
    parse_assign_primitive_value(
        name: match['name'],
        value: (match['value'] == 'true'),
        clazz: world.classes_declarations[BOOLEAN_CLASS_NAME],
        type: BOOLEAN_CLASS_NAME,
        match: match
    )
  end

  # @param [MatchData] match
  def parse_declare_assign_variable(match)
    parse_declare_variable(match)
    parse_assign_variable_or_member(match)
  end

  # @param [MatchData] match
  def parse_declare_assign_integer(match)
    parse_declare_variable(match)
    parse_assign_integer(match)
  end

  # @param [MatchData] match
  def parse_declare_assign_float(match)
    parse_declare_variable(match)
    parse_assign_float(match)
  end

  # @param [MatchData] match
  def parse_declare_assign_boolean(match)
    parse_declare_variable(match)
    parse_assign_boolean(match)
  end

  # @param [MatchData] match
  def parse_assign_variable_or_member(match)
    add_statement(
        Ritournelle::IntermediateRepresentation::Assignment.new(
            file_path: @file_path,
            line_index: @line_index,
            target_name: match['name'],
            value: match['value'],
            value_type: Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER
        )
    )
  end

  # @param [MatchData] match
  def parse_return_integer(match)
    parse_return_primitive_value(
        value: Integer(match['value']),
        clazz: world.classes_declarations[INTEGER_CLASS_NAME],
        type: INTEGER_CLASS_NAME,
        match: match
    )
  end

  # @param [MatchData] match
  def parse_return_float(match)
    parse_return_primitive_value(
        value: Float(match['value']),
        clazz: world.classes_declarations[FLOAT_CLASS_NAME],
        type: FLOAT_CLASS_NAME,
        match: match
    )
  end

  # @param [MatchData] match
  def parse_return_boolean(match)
    parse_return_primitive_value(
        value: match['value'] == true,
        clazz: world.classes_declarations[BOOLEAN_CLASS_NAME],
        type: BOOLEAN_CLASS_NAME,
        match: match
    )
  end

  # @param [String] name
  # @param [Integer|Float] value
  # @param [Ritournelle::IntermediateRepresentation::ClassDeclaration] clazz
  # @param [String] type
  # @param [MatchData] match
  def parse_assign_primitive_value(name:, value:, clazz:, type:, match:)
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        type: clazz.name,
        parameters: [value],
        parameters_types: [type],
        generics: []
    )
    add_statement(
        Ritournelle::IntermediateRepresentation::Assignment.new(
            file_path: @file_path,
            line_index: @line_index,
            target_name: name,
            value: constructor_call,
            value_type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
        )
    )
  end

  # @param [Integer|Float] value
  # @param [String] type
  # @param [MatchData] match
  def parse_return_primitive_value(value:, clazz:, type:, match:)
    constructor_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        type: clazz.name,
        parameters: [value],
        parameters_types: [type],
        generics: []
    )
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: constructor_call,
        type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR,
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
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] }
    ))
  end

  # @param [MatchData] match
  def parse_setter_call(match)
    call_parameters = process_method_call_parameters(match)
    add_statement(Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        element_name: match['element'],
        method_name: "#{match['method']}=",
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] }
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
    extract_generics(match).each do |name|
      declare_generic(name)
    end
  end

  def declare_generic(name)
    @stack.last.generics_declarations.each do |generic_declaration|
      if generic_declaration.name == name
        raise_error("Generic [#{name}] already exists")
      end
    end
    generic_declaration = Ritournelle::IntermediateRepresentation::GenericDeclaration.new(
        file_path: @file_path,
        line_index: @line_index,
        name: name
    )
    add_statement(generic_declaration)
    @stack.last.generics_declarations << generic_declaration
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
    if @stack.last.members.key?(name)
      raise_error("Member [#{name}] already exists")
    end
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
          type: Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER,
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
      add_statement(
          Ritournelle::IntermediateRepresentation::Assignment.new(
              file_path: @file_path,
              line_index: @line_index,
              target_name: name,
              value: short_name,
              value_type: Ritournelle::IntermediateRepresentation::Type::TYPE_PARAMETER
          )
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
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] }
    )
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        target_name: match['name'],
        value: method_call,
        value_type: Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL
    )
    )
  end


  # @param [MatchData] match
  def parse_declare_variable_assign_method_call(match)
    parse_declare_variable(match)
    parse_assign_method_call(match)
  end

  # @param [MatchData] match
  def parse_assign_constructor_call(match)
    generics = extract_generics(match)
    call_parameters = process_method_call_parameters(match)
    method_call = Ritournelle::IntermediateRepresentation::ConstructorCall.new(
        file_path: @file_path,
        line_index: @line_index,
        type: match['class'],
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] },
        generics: generics
    )
    add_statement(Ritournelle::IntermediateRepresentation::Assignment.new(
        file_path: @file_path,
        line_index: @line_index,
        target_name: match['name'],
        value: method_call,
        value_type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR
    )
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
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] }
    )
    add_statement(Ritournelle::IntermediateRepresentation::Return.new(
        file_path: @file_path,
        line_index: @line_index,
        value: method_call,
        type: Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL,
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
  # @return [Array<Hash>]
  def process_method_call_parameters(match)
    if match['parameters'].nil?
      return []
    end

    match['parameters'].strip.split(',').collect do |call_parameter|
      c = call_parameter.strip
      if RX_PARAMETER_INT.match(c)
        {
            type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR,
            value:
                Ritournelle::IntermediateRepresentation::ConstructorCall.new(
                    file_path: @file_path,
                    line_index: @line_index,
                    parameters: [Integer(c)],
                    type: world.classes_declarations[INTEGER_CLASS_NAME].name,
                    parameters_types: [INTEGER_CLASS_NAME],
                    generics: []
                )
        }
      elsif RX_PARAMETER_FLOAT.match(c)
        {
            type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR,
            value:
                Ritournelle::IntermediateRepresentation::ConstructorCall.new(
                    file_path: @file_path,
                    line_index: @line_index,
                    parameters: [Float(c)],
                    type: world.classes_declarations[FLOAT_CLASS_NAME].name,
                    parameters_types: [FLOAT_CLASS_NAME],
                    generics: []
                )
        }
      elsif RX_PARAMETER_BOOLEAN.match(c)
        {
            type: Ritournelle::IntermediateRepresentation::Type::TYPE_CONSTRUCTOR,
            value:
                Ritournelle::IntermediateRepresentation::ConstructorCall.new(
                    file_path: @file_path,
                    line_index: @line_index,
                    parameters: [c == 'true'],
                    type: world.classes_declarations[BOOLEAN_CLASS_NAME].name,
                    parameters_types: [BOOLEAN_CLASS_NAME],
                    generics: []
                )
        }
      else
        {
            type: Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER,
            value: c
        }
      end
    end
  end

  # @param [MatchData] match
  def parse_if_variable_or_member(match)
    value = match['value']
    conditional_expression = Ritournelle::IntermediateRepresentation::ConditionalExpression.new(
        file_path: @file_path,
        line_index: @line_index,
        conditional_statement: value,
        conditional_statement_type: Ritournelle::IntermediateRepresentation::Type::TYPE_VARIABLE_OR_MEMBER,
    )
    add_statement(conditional_expression)
    @stack << conditional_expression
  end

  # @param [MatchData] match
  def parse_if_method_call(match)
    call_parameters = process_method_call_parameters(match)
    method_call = Ritournelle::IntermediateRepresentation::MethodCall.new(
        file_path: @file_path,
        line_index: @line_index,
        element_name: match['element'],
        method_name: match['method'],
        parameters: call_parameters.map { |v| v[:value] },
        parameters_types: call_parameters.map { |v| v[:type] }
    )
    conditional_expression = Ritournelle::IntermediateRepresentation::ConditionalExpression.new(
        file_path: @file_path,
        line_index: @line_index,
        conditional_statement: method_call,
        conditional_statement_type: Ritournelle::IntermediateRepresentation::Type::TYPE_METHOD_CALL,
    )
    add_statement(conditional_expression)
    @stack << conditional_expression
  end

  # @param [String] message
  # @raise [RuntimeError]
  def raise_error(message)
    raise RuntimeError, message, ["#{@file_path}:#{@line_index + 1}"]
  end

  # @param [String] name
  # @raise [RuntimeError]
  def check_class_or_interface_don_t_exist(name)
    if @world.interfaces_declarations.key?(name) || @world.classes_declarations.key?(name)
      raise_error("Class or interface [#{name}] already exists")
    end
  end

  # @param [MatchData] match
  # @return [Array<String>]
  def extract_generics(match)
    if match['last_generic'] && (!match['last_generic'].empty?)
      generics = []
      unless match['generics'].empty?
        match['generics'].split(',').map(&:strip).each do |name|
          unless name.empty?
            generics << name
          end
        end
      end
      generics + [match['last_generic']]
    else
      []
    end
  end

end
