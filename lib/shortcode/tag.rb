class Shortcode::Tag

  def initialize(name, attributes=[], content='', additional_attributes=nil)
    include_helper_modules
    @name       = name.downcase
    presenter   = Shortcode::Presenter.new name, set_attributes(attributes), content, additional_attributes
    @attributes = presenter.attributes
    @content    = presenter.content
  end

  def set_attributes(attributes)
    hash = {}
    attributes.each { |o| hash[o[:key].to_sym] = o[:value] }
    hash
  end

  def markup
    return markup_from_config unless Shortcode.configuration.templates.nil?
    template_files.each do |path|
      return File.read(path) if File.file? path
    end
    raise Shortcode::TemplateNotFound, "Searched in:", template_files
  end

  def render
    render_template
  end

  private

    def include_helper_modules
      return unless Shortcode.configuration.helpers.any?
      class << self
        Shortcode.configuration.helpers.each do |helper|
          include helper
        end
      end
    end

    def render_template
      case Shortcode.configuration.template_parser
      when :erb
        ERB.new(markup).result(binding)
      when :haml
        Haml::Engine.new(markup, ugly: true).render(binding)
      when :slim
        Slim::Template.new { markup }.render(self)
      else
        raise Shortcode::TemplateParserNotSupported, Shortcode.configuration.template_parser
      end
    end

    def markup_from_config
      if Shortcode.configuration.templates.has_key? @name.to_sym
        Shortcode.configuration.templates[@name.to_sym]
      else
        raise Shortcode::TemplateNotFound, "Shortcode.configuration.templates does not contain the key #{@name.to_sym}"
      end
    end

    def template_files
      template_paths.map do |filename|
        File.join Shortcode.configuration.template_path, filename
      end
    end

    def template_paths
      [ "#{@name}.html.#{Shortcode.configuration.template_parser.to_s}", "#{@name}.#{Shortcode.configuration.template_parser.to_s}" ]
    end
end
