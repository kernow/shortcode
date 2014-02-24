# Shortcode

A ruby gem for parsing Wordpress style shortcodes. The gem uses a [PEG](http://en.wikipedia.org/wiki/Parsing_expression_grammar) (Parsing Expression Grammar) parser rather than using regular expressions so its easier to understand, test and extend.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shortcode'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install shortcode
```

## Usage

### Example

Shortcode can be used in one of two ways, the parser and transformer can be called seperatly or the `process` method can be used which performs both the parsing and transforming and returns the result.

The shorthand wraps up the above code into a single method call for convenience

```ruby
Shortcode.process("[quote]Hello World[/quote]")
```

The longer form is good if you want to work with the intemediary hash returned by the parser

```ruby
parser = Shortcode::Parser.new
transformer = Shortcode::Transformer.new
parsed_hash = parser.parse("[quote]Hello World[/quote]")
transformer.apply(parsed_hash)
```

### Configuration

```ruby
Shortcode.setup do |config|

  # the template parser to use
  config.template_parser = :haml # :erb or :haml supported, :haml is default

   # location of the template files
  config.template_path = "support/templates/haml"

  # a list of block tags to support e.g. [quote]Hello World[/quote]
  config.block_tags = [:quote]

  # a list of self closing tags to support e.g. [youtube id="12345"]
  config.self_closing_tags = [:youtube]
end
```

### Templates

Each shortcode tag needs a template file to translate the shortcode into html. Templates can be written in HAML or erb and work in
a similar way to views in Rails. The main content of a tag is passed via the instance variable `@content`. Any attributes defined on a tag are passed in via an `@attributes` hash, shortcodes can have any number of attributes. For instance a quote shortcode might look like this:

    [quote author="Homer Simpson"]Doh![/quote]

And the haml template to render the shortcode

```haml
%blockquote
  %p.quotation= @content
  -if @attributes[:author]
    %p.citation
      %span.author= @attributes[:author]
```

If using the gem within a Rails project you can use the Rails helper methods within template files.

Shortcodes can be nested inside other shortcodes, there are no limits imposed on the nesting depth. This can be useful when creating complex content such as a collapsible list that can have any content inside each element. We could have the following shortcodes

    [collapsible_list]
      [item]
        [youtube id="12345"]
      [/item]
      [item]Hellow World[/item]
    [/collapsible_list]

Three templates would be required to support the above content, `[:collapsible_list, :item, :youtube]`. Each template is rendered in isolation and has no knowledge of parent or child elements.

### Presenters

Sometimes the data passed to the template from the shortcode it not enough. Lets say you want to render a gallery of images using id numbers of images stored in a database, e.g. `[gallery ids="1,2,3,4"]`. This is where presenters can help, they allow you to modify the `@content` and `@attributes` variables before they are sent to the template for rendering. Presenters are simple classes that define four methods. The class method `for` should return the name of the shortcode (as a symbol) it should be applied to. The classes `initialize` method received the `attributes` and `content` variables. Finally the class should define `content` and `attributes` methods.

In a rails app you could return image records to the template using something like this:

```ruby
class CustomPresenter

  def self.for
    :quote
  end

  def initialize(attributes, content)
    @attributes = attributes
    @content = content
  end

  def content
    @content
  end

  def attributes
    { images: images }
  end

  private

    def images
      Image.where("id IN (?)", @attributes[:ids])
    end
end
```

#### Registering presenters

To register a presenter simply call `Shortcode.register_presenter` passing the presenter class e.g.

```ruby
Shortcode.register_presenter(CustomPrsenter)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
