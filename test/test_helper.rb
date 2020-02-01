$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'simplecov'

SimpleCov.start

require 'ritournelle'
require 'ritournelle/parser'
require 'ritournelle/code_generator'
require 'ritournelle/runtime'

require 'minitest/autorun'
