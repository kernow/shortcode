# Shortcode

Shortcode is a ruby gem for parsing Wordpress style shortcodes, I created it while building a CMS for a client through [my ruby consultancy, Kernow Soul](http://kernowsoul.com). The gem uses a [PEG](http://en.wikipedia.org/wiki/Parsing_expression_grammar) (Parsing Expression Grammar) parser rather than using regular expressions so its easier to understand, test and extend.

[![Gem Version](https://badge.fury.io/rb/shortcode.svg)](http://badge.fury.io/rb/shortcode)
[![Build Status](https://travis-ci.org/kernow/shortcode.png?branch=master)](https://travis-ci.org/kernow/shortcode)
[![Code Climate](https://codeclimate.com/github/kernow/shortcode.png)](https://codeclimate.com/github/kernow/shortcode)
[![Coverage Status](https://coveralls.io/repos/kernow/shortcode/badge.png)](https://coveralls.io/r/kernow/shortcode)

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

Shortcode is tested against ruby version 1.9.2 and greater as well as jruby, it will not work with ruby 1.8. Shortcode rails integration is tested against
Rails versions 3.0, 3.1, 3.2, 4.0, and 4.1.

## Usage

### Example

Shortcode is very simple to use, simply call the `process` method and pass it a string containing shortcode markup.

```ruby
Shortcode.process("[quote]Hello World[/quote]")
```

### Templates

Each shortcode tag needs a template in order to translate the shortcode into html (or other output). Templates can be written in erb, haml or slim and work in
a similar way to views in Rails. The main content of a tag is passed via the instance variable `@content`. Any attributes defined on a tag are passed in via an `@attributes` hash, shortcodes can have any number of attributes. For instance a quote shortcode might look like this:

    [quote author="Homer Simpson"]Doh![/quote]

And the erb template to render the shortcode

```erb
<blockquote>
  <p class='quotation'>
    <%= @content %>
  </p>
  <% if @attributes[:author] %>
    <p class='citation'>
      <span class='author'>
        <%= @attributes[:author] %>
      </span>
    </p>
  <% end %>
</blockquote>
```

If using the gem within a Rails project you can use the Rails helper methods within templates.

Shortcodes can be nested inside other shortcodes, there are no limits imposed on the nesting depth. This can be useful when creating complex content such as a collapsible list that can have any content inside each element. We could have the following shortcodes

    [collapsible_list]
      [item]
        [youtube id="12345"]
      [/item]
      [item]Hellow World[/item]
    [/collapsible_list]

Three templates would be required to support the above content, `[:collapsible_list, :item, :youtube]`. Each template is rendered in isolation and has no knowledge of parent or child elements.

There are 2 ways templates can be used with Shortcode, the default it to load templates from the file system, an alternative approach is to pass templates to the setup
block as strings.

#### Templates loaded from the file system

Simply create files with the extension or .erb, .haml, or .slim with a filename the same as the shortcode tag, e.g. gallery.html.erb would render a [gallery] shortcode tag. The default
location for template files is `app/views/shortcode_templates`, if you want to load tempaltes from a different location use the `template_path` config option.

#### Templates set as configuration options

The alternative way to define tempaltes is to set them using the `templates` config option, this option can take a hash with keys of the same name as the shortcode tags and
values containing a template string. For instance:

```ruby
Shortcode.setup do |config|
  config.templates = { gallery: 'template code' }
end
```

If the `templates` config option is set all templates will be loaded from this hash, if a shortcode is encountered without a matching key in the `templates` config option
an exception will be raised.

### Presenters

Sometimes the data passed to the template from the shortcode it not enough. Lets say you want to render a gallery of images using id numbers of images stored in a database, e.g. `[gallery ids="1,2,3,4"]`. This is where presenters can help, they allow you to modify the `@content` and `@attributes` variables before they are sent to the template for rendering. Presenters are simple classes that define four methods. The class method `for` should return the name of the shortcode (as a symbol) it should be applied to, the `for` method can also return an array of symbols if the presenter is to be used for multiple shortcodes. The classes `initialize` method received the `attributes`, `content` and `additional_attributes` variables. Finally the class should define `content` and `attributes` methods.

In a rails app you could return image records to the template using something like this:

```ruby
class GalleryPresenter

  def self.for
    # An array can also be returned if the presenter should be applied
    # to multiple shortcodes, e.g. [:gallery, :enhanced_gallery]
    :gallery
  end

  def initialize(attributes, content, additional_attributes)
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

#### Using additional attributes

At times you may want to pass through additional attributes to a presenter, for instance if you have a [gallery] shortcode tag and you want to pull out all images for a post, this can be achived using additional attributes with a presenter.

```ruby
class GalleryPresenter

  def self.for
    :gallery
  end

  def initialize(attributes, content, additional_attributes)
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

# The hash containing the images attribute is passed through to the presenter
# as the additional_attributes argument
Shortcode.process('[gallery]', { images: @post.images })

```

#### Registering presenters

To register a presenter simply call `Shortcode.register_presenter` passing the presenter class e.g.

```ruby
Shortcode.register_presenter(CustomPresenter)
```

### Configuration

```ruby
Shortcode.setup do |config|

  # the template parser to use
  config.template_parser = :erb # :erb, :haml, :slim supported, :erb is default

   # location of the template files, default is "app/views/shortcode_templates"
  config.template_path = "support/templates/erb"

   # a hash of templates passed as strings, if this is set it overrides the
   # above template_path option. The default is nil
  config.templates = { gallery: 'template code' }

  # a list of block tags to support e.g. [quote]Hello World[/quote]
  config.block_tags = [:quote]

  # a list of self closing tags to support e.g. [youtube id="12345"]
  config.self_closing_tags = [:youtube]

  # the type of quotes to use for attribute values, default is double quotes (")
  config.quotes = '"'
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
