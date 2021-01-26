require 'simplecov'
require 'simplecov-json'
require 'factory_girl_rails'

ENV['RAILS_ENV'] ||= 'test'

MINIMUM_COVERAGE = 27
SimpleCov.at_exit do
  abort "Too low coverage. Expected #{MINIMUM_COVERAGE} was #{SimpleCov.result.covered_percent}" if SimpleCov.result.covered_percent < MINIMUM_COVERAGE
  SimpleCov.result.format!
end
SimpleCov.start 'rails' do
  add_filter 'vendor'
end

require File.expand_path('../config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
end
