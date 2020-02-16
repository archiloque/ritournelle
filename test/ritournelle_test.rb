require 'test_helper'
require 'json'

# Run all tests in 'cases' directory
# We create a test method for each case so we have a nice reporting
class RitournelleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ritournelle::VERSION
  end

  Dir[File.join(__dir__, 'cases', '*')].each do |test_case_dir|
    RitournelleTest.define_method("test_#{File.basename(test_case_dir)}") do
      run_test(test_case_dir)
    end
  end

  private

  def run_test(test_case_dir)
    input_file_name = File.join(test_case_dir, 'input.rit')
    output_file_name = File.join(test_case_dir, 'output.rit.rb')
    error_file_name = File.join(test_case_dir, 'output.error')
    result_file_name = File.join(test_case_dir, 'result.json')

    test_case_content = IO.read(input_file_name)
    if File.exist?(output_file_name)
      parser = Ritournelle::Parser.new(code: test_case_content, file_path: input_file_name)
      world = parser.world
      generator = Ritournelle::CodeGenerator.new(world: world)
      generated_output = generator.result.join("\n")
      assert_equal(
          IO.read(output_file_name),
          generated_output,
          "Difference detected in [#{output_file_name}]")
      if File.exist?(result_file_name)
        # Execute the code in the context of a new object so there's no interferences between tests
        result = Object.new.instance_eval(generated_output, output_file_name)
        expected_result = JSON.parse(IO.read(result_file_name))
        expected_class = expected_result['class'].split('::').inject(Object) { |o, c| o.const_get c }
        assert_instance_of(expected_class, result)
        expected_result['attributes'].each_pair do |attribute_name, attribute_value|
          assert_equal(attribute_value, result.send(attribute_name))
        end
      end
    elsif File.exist?(error_file_name)
      error = assert_raises(RuntimeError) do
        parser = Ritournelle::Parser.new(code: test_case_content, file_path: input_file_name)
        world = parser.world
        Ritournelle::CodeGenerator.new(world: world)
      end
      assert_equal(
          IO.read(error_file_name),
          error.message,
          "Difference detected in [#{error_file_name}]")
      IO.read(error_file_name)
    else
      raise "Don't known what to test for [#{test_case_dir}]"
    end
  end

end
