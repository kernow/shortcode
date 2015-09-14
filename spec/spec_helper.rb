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

  config.before(:each) do
    Shortcode::Presenter.presenters = {}
    Shortcode.setup do |config|
      config.template_parser = :erb
      config.template_path = File.join File.dirname(__FILE__), "support/templates/erb"
      config.templates = nil
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person, :rails_helper, :custom_helper]
      config.self_closing_tags = [:timeline_event, :timeline_info]
      config.attribute_quote_type = '"'
      config.use_attribute_quotes = true
    end
  end
end
