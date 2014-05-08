# Shortcode

[![Build Status](https://travis-ci.org/kernow/shortcode.png?branch=master)](https://travis-ci.org/kernow/shortcode)

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

Shortcode is very simple to use, simply call the `process` method and pass it a string containing shortcode markup.

```ruby
Shortcode.process("[quote]Hello World[/quote]")
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

  # the type of quotes to use for attribute values, default is double quotes (")
  config.quotes = '"'
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

Sometimes the data passed to the template from the shortcode it not enough. Lets say you want to render a gallery of images using id numbers of images stored in a database, e.g. `[gallery ids="1,2,3,4"]`. This is where presenters can help, they allow you to modify the `@content` and `@attributes` variables before they are sent to the template for rendering. Presenters are simple classes that define four methods. The class method `for` should return the name of the shortcode (as a symbol) it should be applied to. The classes `initialize` method received the `attributes`, `content` and `additional_attributes` variables. Finally the class should define `content` and `attributes` methods.

In a rails app you could return image records to the template using something like this:

```ruby
class GalleryPresenter

  def self.for
    :gallery
  end

  def initialize(attributes, content, additional_attributes)
    @attributes = attributes
    @content = content
    @additional_attributes = additional_attributes
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

#### Using additional attributes

At times you may want to pass through additional attributes to a presenter, for instance if you have a [gallery] shortcode tag and you want to pull out all images for a post, this can be achived using additional attributes with a presenter.

```ruby
class GalleryPresenter

  def self.for
    :gallery
  end

  def initialize(attributes, content, additional_attributes)
    @attributes = attributes
    @content = content
    @additional_attributes = additional_attributes
  end

  def content
    @content
  end

  def attributes
    { images: images }
  end

  private

    def images
      @additional_attributes[:images].map &:url
    end
end

# The hash containing the images attribute is passed through to the presenter as the additional_attributes argument
Shortcode.process('[gallery]', { images: @post.images })

```

#### Registering presenters

To register a presenter simply call `Shortcode.register_presenter` passing the presenter class e.g.

```ruby
Shortcode.register_presenter(CustomPresenter)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
