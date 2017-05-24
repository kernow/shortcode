class Shortcode::Configuration
  # Sets the template parser to use, supports :erb, :haml, and :slim, default is :haml
  attr_accessor :template_parser

  # Sets the path to search for template files
  attr_accessor :template_path

  # Allows templates to be set from strings rather than read from the filesystem
  attr_accessor :templates

  # Assigns helper modules to be included in templates
  attr_accessor :helpers

  # Set the supported presenters
  attr_accessor :presenters

  # Set the supported block_tags
  attr_reader :block_tags
  def block_tags=(block_tags)
    @block_tags = block_tags.sort_by(&:length).reverse
  end

  # Set the supported self_closing_tags
  attr_reader :self_closing_tags
  def self_closing_tags=(self_closing_tags)
    @self_closing_tags = self_closing_tags.sort_by(&:length).reverse
  end

  # Set the quotation sign used for attribute values. Defaults to double quote (")
  attr_accessor :attribute_quote_type

  # Allows quotes around attributes to be omitted. Defaults to false (quotes must be present around the value).
  attr_accessor :use_attribute_quotes

  def initialize
    @template_parser      = :erb
    @template_path        = "app/views/shortcode_templates"
    @templates            = nil
    @helpers              = []
    @block_tags           = []
    @self_closing_tags    = []
    @attribute_quote_type = '"'
    @use_attribute_quotes = true
    @presenters = {}
  end

  def register_presenter(presenter)
    validate_presenter presenter
    [*presenter.for].each { |k| presenters[k.to_sym] = presenter }
  end

  private

    def validate_presenter(presenter)
      raise ArgumentError, "The presenter must define the class method #for" unless presenter.respond_to?(:for)
      raise ArgumentError, "The presenter must define an initialize method" unless presenter.private_instance_methods(false).include?(:initialize)
      %w(content attributes).each do |method|
        raise ArgumentError, "The presenter must define the method ##{method}" unless presenter.method_defined?(method.to_sym)
      end
    end

end
