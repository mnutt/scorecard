#require 'rubygems'

$LOAD_PATH.unshift File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. vendor json-1.1.9 lib]))
require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib scorecard]))

require 'mocks'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

# EOF
