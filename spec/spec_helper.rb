$LOAD_PATH.unshift File.dirname(__FILE__)

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'rails'
require 'action_view'
require 'shortcode'
require 'support/fixtures'

# Set slim's attribute quotes to use single quotes so it's the same as haml
Slim::Engine.set_options attr_quote: "'"

RSpec.configure do |config|
  config.order = "random"
end
