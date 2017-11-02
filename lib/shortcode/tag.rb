class Shortcode::Tag

  def initialize(name, configuration, attributes=[], content="", additional_attributes=nil)
    @name = name.downcase
    @configuration = configuration
    @binding = Shortcode::TemplateBinding.new(@name,
                                              @configuration,
                                              attributes,
                                              content,
                                              additional_attributes)
  end

  def markup
    template = first_priority_template
    template = second_priority_template if template.nil?
    return template unless template.nil?
    raise Shortcode::TemplateNotFound, "No template found for #{@name} in configuration or files"
  end

  def render
    render_template
  end

  private

  attr_reader :configuration

  # rubocop:disable Metrics/AbcSize
  def render_template
    case configuration.template_parser
    when :erb
      ERB.new(markup).result(@binding.expose_binding)
    when :haml
      Haml::Engine.new(markup).render(@binding)
    when :slim
      Slim::Template.new { markup }.render(@binding)
    else
      raise Shortcode::TemplateParserNotSupported, configuration.template_parser
    end
  end
  # rubocop:enable Metrics/AbcSize

  def first_priority_template
    configuration.check_config_templates_first ? markup_from_config : markup_from_file
  end

  def second_priority_template
    configuration.check_config_templates_first ? markup_from_file : markup_from_config
  end

  def markup_from_file
    template_files.each do |path|
      return File.read(path) if File.file? path
    end
    nil
  end

  def markup_from_config
    configuration.templates[@name.to_sym]
  end

  def template_files
    template_paths.map do |filename|
      File.join configuration.template_path, filename
    end
  end

  def template_paths
    ["#{@name}.html.#{configuration.template_parser}", "#{@name}.#{configuration.template_parser}"]
  end

end
