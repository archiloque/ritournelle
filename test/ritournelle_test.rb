require 'test_helper'
require 'json'

class RitournelleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ritournelle::VERSION
  end

  def test_cases
    Dir[File.join(__dir__, 'cases', '*')].each do |test_case_dir|
      puts "👉 Testing #{test_case_dir}"

      test_case_file_name = File.join(test_case_dir, 'input.rit')
      output_file_name = File.join(test_case_dir, 'output.rit.rb')
      error_file_name = File.join(test_case_dir, 'output.error')
      result_file_name = File.join(test_case_dir, 'result.json')

      test_case_content = IO.read(test_case_file_name)
      if File.exist?(output_file_name)
        parser = Ritournelle::Parser.new(code: test_case_content)
        world = parser.world
        generator = Ritournelle::CodeGenerator.new(world: world)
        generated_output = generator.result.join("\n")
        assert_equal(IO.read(output_file_name), generated_output)
        if File.exist?(result_file_name)
          result = eval(generated_output, nil, output_file_name, 0)
          expected_result = JSON.parse(IO.read(result_file_name))
          expected_class = expected_result['class'].split('::').inject(Object) { |o, c| o.const_get c }
          assert_instance_of(expected_class, result)
          expected_result['attributes'].each_pair do |attribute_name, attribute_value|
            assert_equal(attribute_value, result.send(attribute_name))
          end
        end
      elsif File.exist?(error_file_name)
        assert_raises(RuntimeError, IO.read(error_file_name)) do
          parser = Ritournelle::Parser.new(code: test_case_content)
          world = parser.world
          Ritournelle::CodeGenerator.new(world: world)
        end
      else
        raise "Don't known what to test for [#{test_case_dir}]"
      end

    end
  end

end
