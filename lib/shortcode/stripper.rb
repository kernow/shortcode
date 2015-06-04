class Shortcode::Stripper < Parslet::Transform

  rule(text: simple(:text)) { String(text) }
  rule(
    open:     simple(:name),
    options:  subtree(:options),
    inner:    sequence(:inner),
    close:    simple(:name)
  ) { '' }
  rule(
    open_close: simple(:name),
    options:    subtree(:options)
  ) { '' }

  rule(body: sequence(:strings)) { strings.join }

end
