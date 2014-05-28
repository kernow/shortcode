require 'parslet'
require 'haml'

begin
  require 'slim'
rescue LoadError; end

require 'erb'

module Shortcode

  class << self
    attr_writer :configuration, :presenters
  end

  def self.process(string, additional_attributes=nil)
    Shortcode::Processor.new.process string, additional_attributes
  end

  def self.setup
    yield configuration
  end

  def self.register_presenter(presenter)
    presenters[presenter.for.to_sym] = presenter
  end

  private

    def self.presenters
      @presenters ||= {}
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

end

require 'shortcode/version'
require 'shortcode/configuration'
require 'shortcode/parser'
require 'shortcode/presenter'
require 'shortcode/processor'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
require 'shortcode/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

Shortcode.setup {}
