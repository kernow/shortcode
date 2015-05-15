## 1.1.0 (May 15, 2015)

Features:

  - Support for registering multiple presenters with a single call

## 1.0.2 (March 4, 2015)

Fixes:

  - Whitespace after tags is now preserved

## 1.0.1 (January 21, 2015)

Features:

  - Implemented a TemplateBinding class as the binding to templates to provide a clean interface
  - Updated to parslet 1.6.2
  - Updated to rspec 3.1

Misc:

  - Testing against the latest versions of Rails 3.1, 3.2, 4.0, 4.1 & 4.2
  - Testing against the latest versions of Ruby 1.9.3-p551, 2.0.0-p598, 2.1.5 & 2.2.0
  - Dropped test support for Rails 3.0
  - Dropped test support for run 1.9.2
  - README improvements

## 1.0.0 (July 29, 2014)

Features:

  - Adds support for attributes without quotations around them

Breaking Changes:

  - Renamed configuration options so they are more clear


## 0.4.3 (July 16, 2014)

Features:

  - Adds support for custom helpers in templates


## 0.4.2 (July 1, 2014)

Features:

  - Adds presenter class method validation


## 0.4.1 (June 18, 2014)

Features:

  - Adds support to apply a single presenter to multiple short code snippets

Misc:

  - Prevent coveralls from running locally
  - Updated to rspec 3


## 0.4.0 (June 16, 2014)

Features:

  - Switched to erb as the default template language and removed dependency on haml


## 0.3.3 (June 3, 2014)

Misc:

  - Added haml default template parser deprecation message


## 0.3.1 (May 30, 2014)

Features:

  - Added support for slim templates (@keichan34)
  - Updated rails versions to test against and updated read me with tested versions of ruby/rails


## 0.3.0 (May 13, 2014)

Features:

  - Added config option to support loading templates from strings


## 0.2.0 (May 9, 2014)

Features:

  - Presenters now support additional attributes
  - Updated parslet gem to 1.6.0 for performance improvements
  - Add config option for quotation sign (@lenart)


## 0.1.2 (March 18, 2014)

Features:

  - Test suite runs against multiple version of ruby and rails

Bugfixes:

  - Presenters are now initialised correctly, allow gem to be used without needing to call Shortcode.setup (fixes #6)
  - Only include rails helpers in rails version 3 or higher

Misc:

  - Simplify presenter image lookup in README (@chrsgrrtt)


## 0.1.1 (February 23, 2014)

Features:

  - Support rails helpers in templates when used within a rails project


## 0.1.0 (February 23, 2014)

Features:

  - Presenters added


## 0.0.4 (February 23, 2014)

Bugfixes:

  - Support configurations with empty tag arrays (fixes #1)


## 0.0.3 (August 23, 2013)

Misc:

  - Relaxed haml version requirement
  - Removed dependency on the facets gem


## 0.0.2 (August 7, 2013)

Features:

  - Added a convenience method to parse and transform at the same time
  - Added examples to README
  - Changed default tags in config
  - Changed @options variable to @attributes in templates to better describe what it is
  - Change the @text variable to @content in templates


## 0.0.1 (August 5, 2013)

Initial Release
