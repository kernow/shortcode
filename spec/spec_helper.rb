$LOAD_PATH.unshift File.dirname(__FILE__)

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rails'
require 'action_view'
require 'shortcode'
require 'support/fixtures'
require 'support/custom_expectations/write_expectation'

# Set slim's attribute quotes to use single quotes so it's the same as haml
Slim::Engine.set_default_options attr_quote: "'"

RSpec.configure do |config|
  config.order = "random"

  config.before(:each) do
    Shortcode.presenters = {}
    Shortcode.setup do |config|
      config.template_parser = :haml
      config.parser_set = false
      config.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.quotes = '"'
    end
  end
end
