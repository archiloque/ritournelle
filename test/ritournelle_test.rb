require "test_helper"

class RitournelleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ritournelle::VERSION
  end

  def test_cases
    Dir[File.join(__dir__, 'cases', '*')].each do |test_case_dir|
      test_case_file_name = File.join(test_case_dir, 'input.rit')
      result_file_name = File.join(test_case_dir, 'output.rit.rb')
      error_file_name = File.join(test_case_dir, 'output.error')
      test_case_content = IO.read(test_case_file_name)
      if File.exist?(result_file_name)
        parser = Ritournelle::Parser.new(test_case_content)
        world = parser.world
        generator = Ritournelle::CodeGenerator.new(world)
        result = generator.result.join("\n")
        assert_equal(IO.read(result_file_name), result)
      elsif File.exist?(error_file_name)
        begin
          parser = Ritournelle::Parser.new(test_case_content)
          world = parser.world
          generator = Ritournelle::CodeGenerator.new(world)
        rescue Exception => e
          assert_equal(IO.read(error_file_name), e.message)
        end
      else
        raise "Dont known what to test for [#{test_case_dir}]"
      end

    end
  end

end
