module Shortcode

  # Raised when the template file can not be found
  class TemplateNotFound < StandardError; end

  # Raised when the template renderer specified is not supported
  class TemplateParserNotSupported < StandardError; end

end
