require 'parslet'
require 'erb'

begin
  require 'haml'
rescue LoadError; end

begin
  require 'slim'
rescue LoadError; end

class Shortcode
  # This is providedc for backwards compatibility
  def self.process(string, additional_attributes=nil)
    warn "[DEPRECATION] singleton `Shortcode.process` is deprecated and will be removed in version 2.0. Please create a new instance `Shortcode.new` and call `process` on the instance."
    singleton.process(string, additional_attributes)
  end

  # This is provided for backwards compatibility
  def self.singleton
    @instance ||= new
  end

  # This is providedc for backwards compatibility
  def self.setup(&prc)
    warn "[DEPRECATION] singleton `Shortcode.setup` is deprecated and will be removed in version 2.0. Please create a new instance `Shortcode.new` and call `setup` on the instance."
    singleton.setup(&prc)
  end

  # This is providedc for backwards compatibility
  def self.register_presenter(*presenters)
    warn "[DEPRECATION] singleton `Shortcode.register_presenter` is deprecated and will be removed in version 2.0. Please create a new instance `Shortcode.new` and call `register_presenter` on the instance."
    singleton.register_presenter(*presenters)
  end

  def process(string, additional_attributes=nil)
    Shortcode::Processor.new.process(string, configuration, additional_attributes)
  end

  def setup
    yield configuration
  end

  def register_presenter(*presenters)
    presenters.each do |presenter|
      configuration.register_presenter(presenter)
    end
  end

  private

  def configuration
    @configuration ||= Configuration.new
  end
end

require 'shortcode/version'
require 'shortcode/configuration'
require 'shortcode/parser'
require 'shortcode/presenter'
require 'shortcode/processor'
require 'shortcode/template_binding'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
require 'shortcode/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

Shortcode.setup {}
