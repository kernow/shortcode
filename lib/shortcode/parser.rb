class Shortcode::Parser < Parslet::Parser

  def initialize(configuration)
    self.class.rule(:block_tag)        { match_any_of configuration.block_tags }
    self.class.rule(:self_closing_tag) { match_any_of configuration.self_closing_tags }

    self.class.rule(:quotes) { str(configuration.attribute_quote_type) }

    self.class.rule(:space)        { str(' ').repeat(1) }
    self.class.rule(:space?)       { space.maybe }
    self.class.rule(:newline)      { (str("\r\n") | str("\n")) >> space? }
    self.class.rule(:newline?)     { newline.maybe }
    self.class.rule(:whitespace)   { (space | newline).repeat(1) }

    self.class.rule(:key) { match('[a-zA-Z0-9\-_]').repeat(1) }

    self.class.rule(:value_with_quotes) { quotes >> (quotes.absent? >> any).repeat.as(:value) >> quotes }
    self.class.rule(:value_without_quotes) { quotes.absent? >> ( (str(']') | whitespace).absent? >> any ).repeat.as(:value) }
    self.class.rule(:value) { configuration.use_attribute_quotes ? value_with_quotes : (value_without_quotes | value_with_quotes) }

    self.class.rule(:option)   { key.as(:key) >> str('=') >> value }
    self.class.rule(:options)  { (str(' ') >> option).repeat(1) }
    self.class.rule(:options?) { options.repeat(0, 1) }

    self.class.rule(:open)       { str('[') >> block_tag.as(:open) >> options?.as(:options) >> str(']') >> newline? }
    self.class.rule(:close)      { str('[/') >> block_tag.as(:close) >> str(']') >> newline? }
    self.class.rule(:open_close) { str('[') >> self_closing_tag.as(:open_close) >> options?.as(:options) >> str(']') >> newline? }

    self.class.rule(:text)   { ((close | block | open_close).absent? >> any).repeat(1).as(:text) }
    self.class.rule(:block)  { (open >> (block | text | open_close).repeat.as(:inner) >> close) }

    self.class.rule(:body) { (block | text | open_close).repeat.as(:body) }
    self.class.root(:body)
  end
  
  private

    def match_any_of(tags)
      return str('') if tags.length < 1
      tags.map{ |tag| str(tag) }.inject do |tag_chain, tag|
        tag_chain.send :|, tag
      end
    end

end
