class Shortcode::Tag

  def initialize(name, configuration, attributes=[], content='', additional_attributes=nil)
    @name = name.downcase
    @configuration = configuration
    @binding = Shortcode::TemplateBinding.new(@name, @configuration, attributes, content, additional_attributes)
  end

  def markup
    return markup_from_config unless @configuration.templates.nil?
    template_files.each do |path|
      return File.read(path) if File.file? path
    end
    raise Shortcode::TemplateNotFound, "Searched in:", template_files
  end

  def render
    render_template
  end

  private

    def render_template
      case @configuration.template_parser
      when :erb
        ERB.new(markup).result(@binding.get_binding)
      when :haml
        Haml::Engine.new(markup, ugly: true).render(@binding)
      when :slim
        Slim::Template.new { markup }.render(@binding)
      else
        raise Shortcode::TemplateParserNotSupported, @configuration.template_parser
      end
    end

    def markup_from_config
      if @configuration.templates.has_key? @name.to_sym
        @configuration.templates[@name.to_sym]
      else
        raise Shortcode::TemplateNotFound, "@configuration.templates does not contain the key #{@name.to_sym}"
      end
    end

    def template_files
      template_paths.map do |filename|
        File.join @configuration.template_path, filename
      end
    end

    def template_paths
      [ "#{@name}.html.#{@configuration.template_parser.to_s}", "#{@name}.#{@configuration.template_parser.to_s}" ]
    end
end
