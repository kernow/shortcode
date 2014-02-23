require 'parslet'
require 'haml'
require 'erb'

module Shortcode
  extend self

  attr_accessor :configuration

  def setup
    self.configuration ||= Configuration.new
    yield configuration
  end

  def process(code)
    transformer.apply(parser.parse(code))
  end

  private

    def parser
      @@parser = Shortcode::Parser.new
    end

    def transformer
      @@transformer = Shortcode::Transformer.new
    end

end

require 'shortcode/version'
require 'shortcode/configuration'
require 'shortcode/parser'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
