require 'parslet'
require 'haml'
require 'erb'

module Shortcode
  extend self

  attr_accessor :configuration, :presenters
  @@presenters = {}

  def setup
    self.configuration ||= Configuration.new
    yield configuration
  end

  def process(code)
    transformer.apply(parser.parse(code))
  end

  def register_presenter(presenter)
    self.presenters[presenter.for.to_sym] = presenter
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
require 'shortcode/presenter'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
require 'shortcode/railtie' if defined?(Rails)
