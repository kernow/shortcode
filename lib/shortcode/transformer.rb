class Shortcode::Transformer < Parslet::Transform

  rule(text: simple(:text)) { String(text) }
  rule(
    open:     simple(:name),
    options:  subtree(:options),
    inner:    sequence(:inner),
    close:    simple(:name)
  ) { Shortcode::Tag.new(name.to_s, options).wrap(inner.join) }
  rule(
    open_close: simple(:name),
    options:    subtree(:options)
  ) { Shortcode::Tag.new(name.to_s, options).wrap }

  rule(body: sequence(:strings)) { strings.join }
end
