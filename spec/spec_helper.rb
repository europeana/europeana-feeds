# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear! unless Coveralls.will_run?.nil?

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'

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
