require 'parslet'
require 'haml'
require 'erb'
require 'facets/module/mattr'

module Shortcode

  # Sets the template parser to use, supports :erb and :haml, default is :haml
  mattr_accessor :template_parser
  @@template_parser = :haml

  # Sets the template parser to use, supports :erb and :haml, default is :haml
  mattr_accessor :template_path
  @@template_path = "app/views/shortcode_templates"

  # Set the supported block_tags
  mattr_accessor :block_tags
  @@block_tags = [:quote, :collapsible_list, :item, :timeline_person]

  # Set the supported self_closing_tags
  mattr_accessor :self_closing_tags
  @@self_closing_tags = [:timeline_event, :timeline_info]

  def self.setup
    yield self
  end

end

require 'shortcode/version'
require 'shortcode/parser'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
