$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rspec'
require 'shortcode'
require 'support/fixtures'

RSpec.configure do |config|
  config.order = "random"

  config.before(:each) do
    Shortcode.presenters = {}
    Shortcode.setup do |config|
      config.template_parser = :haml
      config.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person]
      config.self_closing_tags = [:timeline_event, :timeline_info]
    end
  end
end
