class Shortcode::Configuration
  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_parser

  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_path

  # Set the supported block_tags
  attr_accessor :block_tags

  # Set the supported self_closing_tags
  attr_accessor :self_closing_tags

  def initialize
    @template_parser    = :haml
    @template_path      = "app/views/shortcode_templates"
    @block_tags         = []
    @self_closing_tags  = []
  end
end
