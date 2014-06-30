class Shortcode::Presenter

  class << self
    attr_writer :presenters

    def presenters
      @presenters ||= {}
    end

    def register(presenter)
      validate presenter
      [*presenter.for].each { |k| presenters[k.to_sym] = presenter }
    end

    def validate(presenter)
      raise ArgumentError, "The presenter must define the class method #for" unless presenter.respond_to?(:for)
      raise ArgumentError, "The presenter must define an initialize method" unless presenter.private_instance_methods(false).include?(:initialize)
      %w(content attributes).each do |method|
        raise ArgumentError, "The presenter must define the method ##{method}" unless presenter.method_defined?(method.to_sym)
      end
    end
  end

  def initialize(name, attributes, content, additional_attributes)
    @attributes = attributes
    @content = content
    @additional_attributes = additional_attributes
    initialize_custom_presenter(name)
  end

  def content
    @content
  end

  def attributes
    @attributes
  end

  private

    def initialize_custom_presenter(name)
      if Shortcode::Presenter.presenters.has_key? name.to_sym
        presenter   = Shortcode::Presenter.presenters[name.to_sym].new(@attributes, @content, @additional_attributes)
        @attributes = presenter.attributes
        @content    = presenter.content
      end
    end

end
