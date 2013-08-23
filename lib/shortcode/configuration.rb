class Shortcode::Configuration
  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_parser
  @template_parser = :haml

  # Sets the template parser to use, supports :erb and :haml, default is :haml
  attr_accessor :template_path
  @template_path = "app/views/shortcode_templates"

  # Set the supported block_tags
  attr_accessor :block_tags
  @block_tags = [:quote]

  # Set the supported self_closing_tags
  attr_accessor :self_closing_tags
  @self_closing_tags = [:youtube]
end
