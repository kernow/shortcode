require "parslet"
require "erb"

# rubocop:disable Lint/HandleExceptions
begin
  require "haml"
rescue LoadError; end
begin
  require "slim"
rescue LoadError; end
# rubocop:enable Lint/HandleExceptions

class Shortcode

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

  def configuration
    @configuration ||= Configuration.new
  end

end

require "shortcode/version"
require "shortcode/configuration"
require "shortcode/parser"
require "shortcode/presenter"
require "shortcode/processor"
require "shortcode/template_binding"
require "shortcode/transformer"
require "shortcode/tag"
require "shortcode/exceptions"
require "shortcode/railtie" if defined?(Rails) && Rails::VERSION::MAJOR >= 3
