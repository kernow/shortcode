class Shortcode::Parser

  def initialize(configuration)
    @configuration = configuration
    setup_rules
  end

  def parse(string)
    klass_instance.parse(string)
  end

  def open(*args)
    klass_instance.open(*args)
  end

  private

  # This allows us to create a new class with the rules for the specific configuration
  def klass
    @klass ||= Class.new(Parslet::Parser)
  end

  def klass_instance
    @klass_instance ||= klass.new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/LineLength
  def setup_rules
    define_match_any_of

    shortcode_configuration = @configuration
    klass.rule(:block_tag) { match_any_of shortcode_configuration.block_tags }
    klass.rule(:self_closing_tag) { match_any_of shortcode_configuration.self_closing_tags }

    klass.rule(:quotes) { str(shortcode_configuration.attribute_quote_type) }

    klass.rule(:space) { str(" ").repeat(1) }
    klass.rule(:space?) { space.maybe }
    klass.rule(:newline) { (str("\r\n") | str("\n")) >> space? }
    klass.rule(:newline?) { newline.maybe }
    klass.rule(:whitespace) { (space | newline).repeat(1) }

    klass.rule(:key) { match('[a-zA-Z0-9\-_]').repeat(1) }

    klass.rule(:value_with_quotes) { quotes >> (quotes.absent? >> any).repeat.as(:value) >> quotes }
    klass.rule(:value_without_quotes) { quotes.absent? >> ((str("]") | whitespace).absent? >> any).repeat.as(:value) }
    klass.rule(:value) { shortcode_configuration.use_attribute_quotes ? value_with_quotes : (value_without_quotes | value_with_quotes) }

    klass.rule(:option) { key.as(:key) >> str("=") >> value }
    klass.rule(:options) { (str(" ") >> option).repeat(1) }
    klass.rule(:options?) { options.repeat(0, 1) }

    klass.rule(:open) { str("[") >> block_tag.as(:open) >> options?.as(:options) >> str("]") >> newline? }
    klass.rule(:close) { str("[/") >> block_tag.as(:close) >> str("]") >> newline? }
    klass.rule(:open_close) { str("[") >> self_closing_tag.as(:open_close) >> options?.as(:options) >> str("]") >> newline? }

    klass.rule(:text) { ((close | block | open_close).absent? >> any).repeat(1).as(:text) }
    klass.rule(:block) { (open >> (block | text | open_close).repeat.as(:inner) >> close) }

    klass.rule(:body) { (block | text | open_close).repeat.as(:body) }
    klass.root(:body)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/LineLength

  def define_match_any_of
    klass.send(:define_method, :match_any_of) do |tags|
      if tags.empty?
        str("")
      else
        tags.map { |tag| str(tag) }.inject do |tag_chain, tag|
          tag_chain.send :|, tag
        end
      end
    end
  end

end
