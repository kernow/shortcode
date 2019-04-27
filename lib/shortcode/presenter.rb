class Shortcode::Presenter

  def self.register(configuration, presenter)
    validate presenter
    [*presenter.for].each { |k| configuration.presenters[k.to_sym] = presenter }
  end

  def self.validate(presenter)
    raise ArgumentError, "The presenter must define the class method #for" unless presenter.respond_to?(:for)
    raise ArgumentError, "The presenter must define an initialize method" unless init_defined?(presenter)

    %w[content attributes].each do |method|
      unless presenter.method_defined?(method.to_sym)
        raise ArgumentError, "The presenter must define the method ##{method}"
      end
    end
  end

  def self.init_defined?(presenter)
    return false if presenter == Object

    presenter.private_instance_methods(false).include?(:initialize) || init_defined?(presenter.superclass)
  end

  def initialize(name, configuration, attributes, content, additional_attributes)
    @configuration = configuration
    @attributes = attributes
    @content = content
    @additional_attributes = additional_attributes
    initialize_custom_presenter(name)
  end

  attr_reader :content

  attr_reader :attributes

  private

  attr_reader :configuration

  def initialize_custom_presenter(name)
    return unless configuration.presenters.key?(name.to_sym)

    presenter   = configuration.presenters[name.to_sym].new(@attributes, @content, @additional_attributes)
    @attributes = presenter.attributes
    @content    = presenter.content
  end

end
