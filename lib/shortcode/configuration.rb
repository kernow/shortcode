class Shortcode::Configuration
  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_parser

  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_path

  # Allows templates to be set from strings rather than read from the filesystem
  attr_accessor :templates

  # Set the supported block_tags
  attr_accessor :block_tags

  # Set the supported self_closing_tags
  attr_accessor :self_closing_tags

  # Set the quotation sign used for attribute values. Defaults to double quote (")
  attr_accessor :quotes

  def initialize
    @template_parser    = :haml
    @template_path      = "app/views/shortcode_templates"
    @templates          = nil
    @block_tags         = []
    @self_closing_tags  = []
    @quotes             = '"'
  end
end
