class Shortcode::Transformer < Parslet::Transform

  rule(text: simple(:text)) { String(text) }
  rule(
    open:     simple(:name),
    options:  subtree(:options),
    inner:    sequence(:inner),
    close:    simple(:name)
  ) { Shortcode::Tag.new(name.to_s, options, inner.join).render }
  rule(
    open_close: simple(:name),
    options:    subtree(:options)
  ) { Shortcode::Tag.new(name.to_s, options).render }

  rule(body: sequence(:strings)) { strings.join }
end
