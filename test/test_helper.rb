ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    fixture_load_order = %w[
      formation_modules
      formation_plans
      people
      school_classes
      students
      unities
      grades
    ].freeze

    ordered_fixtures = (fixture_load_order + fixture_table_names).uniq
    self.fixture_table_names = ordered_fixtures
    setup_fixture_accessors(ordered_fixtures)

    # Add more helper methods to be used by all tests here...
  end
end
