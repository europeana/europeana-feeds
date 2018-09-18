# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

# Generate Simplecov report
SimpleCov.start

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rspec/rails'
require 'webmock_helper'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
