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
  spec.summary       = "Gem for parsing wordpress style shortcodes in ruby projects"
  spec.homepage      = "https://github.com/kernow/shortcode"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "1.6.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "coveralls", "~> 0"
  spec.add_development_dependency "slim", "~> 3.0"
  spec.add_development_dependency "haml", "~> 4.0"
end
