class Shortcode::Configuration

  # Sets the template parser to use, supports :erb, :haml, and :slim, default is :haml
  attr_accessor :template_parser

  # Sets the path to search for template files
  attr_accessor :template_path

  # Allows templates to be set from strings rather than read from the filesystem
  attr_accessor :templates

  # Allows setting whether templates on the configuration are checked first, or templates in the file system
  attr_accessor :check_config_templates_first

  # Assigns helper modules to be included in templates
  attr_accessor :helpers

  # Allows presenters to be set that can be used to process shortcode arguments before rendered
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

  # Allows quotes around attributes to be omitted. Defaults to false (quotes must be present around the value)
  attr_accessor :use_attribute_quotes

  def initialize
    @template_parser              = :erb
    @template_path                = "app/views/shortcode_templates"
    @templates                    = {}
    @check_config_templates_first = true
    @helpers                      = []
    @block_tags                   = []
    @self_closing_tags            = []
    @attribute_quote_type         = '"'
    @use_attribute_quotes         = true
    @presenters                   = {}
  end

  def register_presenter(presenter)
    Shortcode::Presenter.register(self, presenter)
  end

end
