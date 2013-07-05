$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rspec'
require 'shortcode'
require 'support/fixtures'

RSpec.configure do |config|
  config.order = "random"

  config.before(:each) do
    Shortcode.setup do |config|
      config.template_parser = :haml
      config.template_path = File.join File.dirname(__FILE__), "support/templates/haml"
    end
  end
end
