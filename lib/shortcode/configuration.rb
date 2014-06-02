class Shortcode::Configuration
  # This stores if the parser has been set in a configuration block so that deprication
  # warnings can be issued
  attr_accessor :parser_set

  def haml_deprecation_warning
    "[DEPRECATION] HAML will no longer be the default template parser in version 0.4 of Shortcode. A HAML template has been used without explicitly specifying HAML as the template parser in a setup block. Please set config.template_parser = :haml to suppress this warning"
  end

  # Sets the template parser to use, supports :erb, :haml, and :slim, default is :haml
  attr_accessor :template_parser

  def template_parser=(parser)
    @parser_set = true
    @template_parser = parser
  end

  # Sets the path to search for template files
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
    @parser_set         = false
  end
end
