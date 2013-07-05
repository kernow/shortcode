# Shortcode

A ruby gem for parsing Wordpress style shortcodes. The gem uses a PEG (Parsing Expression Grammar) parser rather than using regular expressions so its easier to understand, test and extend.

## Installation

Add this line to your application's Gemfile:

    gem 'shortcode'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shortcode

## Usage

Example usage

    parser = Shortcode::Parser.new
    transformer = Shortcode::Transformer.new
    transformer.apply(parser.parse("[quote]Hello World[/quote]"))

Configuration

    Shortcode.setup do |config|

      # the template parser to use
      config.template_parser = :haml # :erb or :haml supported, :haml is default

       # location of the template files
      config.template_path = "support/templates/haml"

      # a list of block tags to support e.g. [quote]Hello World[/quote]
      config.block_tags = [:quote, :collapsible_list, :item, :timeline_person]

      # a list of self closing tags to support e.g. [gallery]
      config.self_closing_tags = [:timeline_event, :timeline_info]
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
