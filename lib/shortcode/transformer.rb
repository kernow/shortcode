class Shortcode::Transformer < Parslet::Transform

  def initialize(configuration)
    @configuration = configuration

    self.class.rule(text: simple(:text)) { String(text) }
    self.class.rule(
      open:     simple(:name),
      options:  subtree(:options),
      inner:    sequence(:inner),
      close:    simple(:name)
    ) { Shortcode::Tag.new(name.to_s, @configuration, options, inner.join, additional_attributes).render }
    self.class.rule(
      open_close: simple(:name),
      options:    subtree(:options)
    ) { Shortcode::Tag.new(name.to_s, @configuration, options, '', additional_attributes).render }

    self.class.rule(body: sequence(:strings)) { strings.join }
  end

end
