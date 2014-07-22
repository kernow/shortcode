class Shortcode::Configuration
  # Sets the template parser to use, supports :erb, :haml, and :slim, default is :haml
  attr_accessor :template_parser

  # Sets the path to search for template files
  attr_accessor :template_path

  # Allows templates to be set from strings rather than read from the filesystem
  attr_accessor :templates

  # Assigns helper modules to be included in templates
  attr_accessor :helpers

  # Set the supported block_tags
  attr_accessor :block_tags

  # Set the supported self_closing_tags
  attr_accessor :self_closing_tags

  # Set the quotation sign used for attribute values. Defaults to double quote (")
  attr_accessor :quotes

  # Allows quotes to be omitted. Defaults to false (quotes must be present around the value).
  attr_accessor :optional_quotes

  def initialize
    @template_parser    = :erb
    @template_path      = "app/views/shortcode_templates"
    @templates          = nil
    @helpers            = []
    @block_tags         = []
    @self_closing_tags  = []
    @quotes             = '"'
    @optional_quotes    = false
  end
end
