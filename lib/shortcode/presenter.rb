class Shortcode::Presenter

  def initialize(name, configuration, attributes, content, additional_attributes)
    @configuration = configuration
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
      if @configuration.presenters.has_key? name.to_sym
        presenter   = @configuration.presenters[name.to_sym].new(@attributes, @content, @additional_attributes)
        @attributes = presenter.attributes
        @content    = presenter.content
      end
    end

end
