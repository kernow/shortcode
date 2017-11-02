class Shortcode::Transformer

  def initialize(configuration)
    @configuration = configuration
    setup_rules
  end

  def apply(str, options={})
    klass_instance.apply(str, options)
  end

  private

  def klass
    @klass ||= Class.new(Parslet::Transform)
  end

  def klass_instance
    @klass_instance ||= klass.new
  end

  # rubocop:disable Metrics/AbcSize
  def setup_rules
    config = @configuration

    klass.rule(text: klass.send(:simple, :text)) { String(text) }
    klass.rule(
      open:     klass.send(:simple, :name),
      options:  klass.send(:subtree, :options),
      inner:    klass.send(:sequence, :inner),
      close:    klass.send(:simple, :name)
    ) { Shortcode::Tag.new(name.to_s, config, options, inner.join, additional_attributes).render }
    klass.rule(
      open_close: klass.send(:simple, :name),
      options:    klass.send(:subtree, :options)
    ) { Shortcode::Tag.new(name.to_s, config, options, "", additional_attributes).render }

    klass.rule(body: klass.send(:sequence, :strings)) { strings.join }
  end
  # rubocop:enable Metrics/AbcSize

end
