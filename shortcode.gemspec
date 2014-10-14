# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shortcode/version'

Gem::Specification.new do |spec|
  spec.name          = "shortcode"
  spec.version       = Shortcode::VERSION
  spec.authors       = ["Jamie Dyer"]
  spec.email         = ["jamie@kernowsoul.com"]
  spec.description   = "Gem for parsing wordpress style shortcodes"
  spec.summary       = "Gem for parsing wordpress style shortcodes"
  spec.homepage      = "https://github.com/kernow/shortcode"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "1.6.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "slim", "~> 2.0"
  spec.add_development_dependency "haml", "~> 4.0"

  # Need rails for tests
  spec.add_development_dependency "rails", "~> 4.0"
end
